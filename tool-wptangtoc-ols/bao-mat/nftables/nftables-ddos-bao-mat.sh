#!/bin/bash

. /etc/wptt/tenmien
echo ""
echo ""
echo "Lựa chọn triển khai ddos nftables:"
echo ""
lua_chon_NAME
. /etc/wptt/echo-color
if [[ "$NAME" = "0" || "$NAME" = "" ]]; then
    . /etc/wptt/wptt-wordpress-main 1
fi

pathcheck="/etc/wptt/vhost/.$NAME.conf"
if [[ ! -f "$pathcheck" ]]; then
    clear
	echoDo "Tên miền không tồn tại trên hệ thống này"
    sleep 3
    . /etc/wptt/wptt-wordpress-main 1
    exit
fi


dnf install python3 jq -y

systemctl mask iptables
systemctl stop fail2ban
systemctl disable fail2ban
systemctl mask fail2ban

mkdir -p /usr/local/lsws/$NAME/bao-mat
cp -f /etc/wptt/bao-mat/nftables/anti.py /usr/local/lsws/$NAME/bao-mat

if $(cat /etc/*release | grep -q "AlmaLinux\|Rocky\|CentOS") ; then
systemctl restart crond
else
systemctl restart cron
fi

chmod +x /usr/local/lsws/$NAME/bao-mat/anti.py

sed -i '/log_file_path =/d' /usr/local/lsws/$NAME/bao-mat/anti.py
sed -i "/parser = Parser()/a\ \ \ \ log_file_path = \"/usr/local/lsws/$NAME/access.log\"" /usr/local/lsws/$NAME/bao-mat/anti.py

cat <(crontab -l) | sed "/bao-mat/d" | crontab -
cat <(crontab -l) <(echo "* * * * * python3 /usr/local/lsws/$NAME/bao-mat/anti.py") | crontab -
cat <(crontab -l) <(echo "*/1 * * * * echo '' > /usr/local/lsws/$NAME/logs/access.log") | crontab -


#file config /etc/sysconfig/nftables.conf


if [[ $(cat /etc/sysconfig/nftables.conf | grep 'ipvietnam') = '' ]];then
cp -f /etc/wptt/bao-mat/nftables/nftables.conf /etc/sysconfig
chmod 600 /etc/sysconfig/nftables.conf


#mở port ssh
port_checkssh=$(cat /etc/ssh/sshd_config | grep "Port " | grep -o '[0-9]\+$')
if [[ $port_checkssh = '' ]];then
port_checkssh=22
fi

port_checkssh=$(cat /etc/ssh/sshd_config | grep "Port " | grep -o '[0-9]\+$')
if [[ $port_checkssh = '' ]];then
port_checkssh=22
fi
sed -i "/chain input /a\ \ tcp dport $port_checkssh accept" /etc/sysconfig/nftables.conf
systemctl restart nftables

fi

google=$(curl -s  https://developers.google.com/static/search/apis/ipranges/googlebot.json | jq '.prefixes| .[]|.ipv4Prefix' | sed '/null/d'|  sed 's/"//g' | sed 's/ /\n/g'| sed '/^$/d')
google=$(echo $google | sed 's/ /, /g')
google=$(echo $google | sed 's/^/{ /g' | sed 's/$/ }/g')

nft add element inet filter GGv4 $google

ip_elements_bing=$(nft list set inet filter BINGv4 | awk '/{ /,/}/' | cut -d '=' -f 2)
nft delete element inet filter BINGv4 ${ip_elements_bing}
bing_ip=$(curl -s https://www.bing.com/toolbox/bingbot.json | jq '.prefixes| .[]|.ipv4Prefix' | sed '/null/d'|  sed 's/"//g'|sed 's/ /\n/g' | sed 's/^/\n/g'|sed '/^$/d')
bing_ip=$(echo $bing_ip | sed 's/ /, /g')
bing_ip=$(echo $bing_ip | sed 's/^/{ /g' | sed 's/$/ }/g')
nft add element inet filter BINGv4 $bing_ip

systemctl restart nftables

echo "hoàn tất thiết lập nftables chống ddos"
