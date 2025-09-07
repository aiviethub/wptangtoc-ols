#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/in.h>
#include <linux/tcp.h>
#include <bpf/bpf_helpers.h>

#define THRESHOLD 100 // Ngưỡng đã được nâng lên
#define TIME_WINDOW_NS 1000000000ULL
#define BAN_DURATION_NS (30 * 60 * 1000000000ULL)

struct rate_limit_entry {
    __u64 last_update;
    __u32 packet_count;
};

// Map 1: Whitelist - Các IP này sẽ luôn được cho qua
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 256);
    __type(key, __u32);
    __type(value, __u8);
} whitelist_map SEC(".maps");

// Map 2: Dành cho chương trình Go chặn IP dựa trên log
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 65535);
    __type(key, __u32);
    __type(value, __u64); 
} log_blacklist SEC(".maps");

// Map 3: Dùng để đếm gói tin (tên đã rút gọn)
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, __u32);
    __type(value, struct rate_limit_entry);
} rl_counters SEC(".maps");

// Map 4: Dùng để lưu các IP bị XDP tự động chặn (tên đã rút gọn)
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, __u32);
    __type(value, __u64);
} rl_blacklist SEC(".maps");


SEC("xdp_combined")
int ddos_and_log_protection(struct xdp_md *ctx) {
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    struct ethhdr *eth = data;
    struct iphdr *iph;
    struct tcphdr *tcph;
    
    if ((void *)(eth + 1) > data_end || eth->h_proto != __constant_htons(ETH_P_IP))
        return XDP_PASS;
    
    iph = (void *)(eth + 1);
    if ((void *)(iph + 1) > data_end)
        return XDP_PASS;
        
    __u32 src_ip = iph->saddr;

    // BƯỚC 0: KIỂM TRA WHITELIST ĐẦU TIÊN
    if (bpf_map_lookup_elem(&whitelist_map, &src_ip)) {
        return XDP_PASS;
    }

    __u64 current_time = bpf_ktime_get_ns();
    
    // BƯỚC 1: Kiểm tra danh sách đen từ LOG
    __u64 *log_ban_ts = bpf_map_lookup_elem(&log_blacklist, &src_ip);
    if (log_ban_ts) {
        if (current_time < *log_ban_ts) return XDP_DROP;
        else bpf_map_delete_elem(&log_blacklist, &src_ip);
    }

    // BƯỚC 2: Kiểm tra danh sách đen do RATE-LIMIT
    __u64 *rate_ban_ts = bpf_map_lookup_elem(&rl_blacklist, &src_ip);
    if (rate_ban_ts) {
        if (current_time < *rate_ban_ts) return XDP_DROP;
        else bpf_map_delete_elem(&rl_blacklist, &src_ip);
    }

    // BƯỚC 3: Miễn trừ cho kết nối SSH đã thiết lập
    if (iph->protocol == IPPROTO_TCP) {
        tcph = (void *)iph + iph->ihl * 4;
        if ((void *)(tcph + 1) <= data_end) {
            if (tcph->dest == __constant_htons(22) && tcph->ack) {
                return XDP_PASS;
            }
        }
    }

    // BƯỚC 4: Logic giới hạn tốc độ gói tin
    struct rate_limit_entry *entry = bpf_map_lookup_elem(&rl_counters, &src_ip);
    if (entry) {
        if (current_time - entry->last_update < TIME_WINDOW_NS) {
            __sync_fetch_and_add(&entry->packet_count, 1);
            if (entry->packet_count > THRESHOLD) {
                __u64 ban_until = current_time + BAN_DURATION_NS;
                bpf_map_update_elem(&rl_blacklist, &src_ip, &ban_until, BPF_ANY);
                bpf_map_delete_elem(&rl_counters, &src_ip);
                return XDP_DROP;
            }
        } else {
            entry->last_update = current_time;
            entry->packet_count = 1;
        }
    } else {
        struct rate_limit_entry new_entry = {};
        new_entry.last_update = current_time;
        new_entry.packet_count = 1;
        bpf_map_update_elem(&rl_counters, &src_ip, &new_entry, BPF_ANY);
    }

    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
