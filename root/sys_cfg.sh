#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Configure root password
# -----------------------------------------------------------------------------
echo "root:${ROOT_PASSWORD:-$DEFAULT_PASSWORD}" | chpasswd

echo "$SVD_PORT" > /root/svd_port
echo "$SVD_PASSWORD" > /root/svd_passwd
env > /root/env

# -----------------------------------------------------------------------------
# Configure ShadowsocksR
# -----------------------------------------------------------------------------
# sed -i \
	# -e 's/"server_port".*/"server_port": '$SSR_PORT',/' \
	# -e 's/"password".*/"password": "'${SSR_PASSWORD:-$DEFAULT_PASSWORD}'",/' \
	# -e 's/"method".*/"method": "'${SSR_METHOD:-rc4-md5}'",/' \
	# -e 's/"protocol".*/"protocol": "'${SSR_PROTOCOL:-auth_sha1_v4}'",/' \
	# -e 's/"obfs".*/"obfs": "'${SSR_OBFS:-tls1.2_ticket_auth}'",/' \
	# /root/shadowsocksr/shadowsocks/user-config.json
	
# -----------------------------------------------------------------------------
# Configure supervisor
# -----------------------------------------------------------------------------
# sed -i \
	# -e 's/port=.*/port='$SVD_PORT'/' \
	# -e 's/username=.*/username='${SVD_USERNAME:-$DEFAULT_USERNAME}'/' \
	# -e 's/password=.*/password='${SVD_PASSWORD:-$DEFAULT_PASSWORD}'/' \
	# /etc/supervisord.conf

# sed -i \
	# -e 's/autostart=.*/autostart='${NET_SPEEDER_AUTOSTART:-true}'/' \
	# /etc/supervisord.d/net_speeder.conf
	