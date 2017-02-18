# =============================================================================
# shijh666/centos-ssh
#
# CentOS latest - SSH / SSR / Net Speeder.
#
# =============================================================================
FROM centos:latest
MAINTAINER shijh666

# -----------------------------------------------------------------------------
# Set default environment variables
# -----------------------------------------------------------------------------
ENV ROOT_PASSWORD passwd
ENV SVD_PORT 1080
ENV SSR_PORT 1000
ENV	SSR_PASSWORD passwd
ENV	SSR_METHOD rc4-md5
ENV	SSR_PROTOCOL auth_sha1_v4
ENV	SSR_OBFS tls1.2_ticket_auth
	
# -----------------------------------------------------------------------------
# Install necessary packages
# -----------------------------------------------------------------------------
RUN yum update -y && \
	yum install -y \
		gcc \
		libnet \
		libnet-devel \
		libpcap \
		libpcap-devel \
		openssh-server \
		openssh-clients \
		python-setuptools \
		git && \
	yum clean all
	
RUN easy_install supervisor

# -----------------------------------------------------------------------------
# Configure SSH
# -----------------------------------------------------------------------------
RUN sed -i \
	-e 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' \
	-e 's/^#\?UsePAM.*/UsePAM no/g' \
	/etc/ssh/sshd_config

RUN ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
RUN ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N ''

RUN echo "root:$ROOT_PASSWORD" | chpasswd

EXPOSE 22

# -----------------------------------------------------------------------------
# Install NetSpeeder
# -----------------------------------------------------------------------------

RUN cd /root/ && \
	git clone -b master https://github.com/snooda/net-speeder.git && \
	cd net-speeder/ && \
	sh build.sh && \
	cp -nf net_speeder /usr/bin/ && \
	cd /root/ && \
	rm -rf net-speeder/
	
# -----------------------------------------------------------------------------
# Configure ShadowsocksR
# -----------------------------------------------------------------------------
RUN cd /root/ && \
	git clone -b manyuser https://github.com/shadowsocksr/shadowsocksr.git && \
	cp -nf shadowsocksr/config.json shadowsocksr/shadowsocks/user-config.json
	
RUN sed -i \
	-e 's/"server_port".*/"server_port": '$SSR_PORT',/' \
	-e 's/"password".*/"password": "'$SSR_PASSWORD'",/' \
	-e 's/"method".*/"method": "'$SSR_METHOD'",/' \
	-e 's/"protocol".*/"protocol": "'$SSR_PROTOCOL'",/' \
	-e 's/"obfs".*/"obfs": "'$SSR_OBFS'",/' \
	/root/shadowsocksr/shadowsocks/user-config.json
	
EXPOSE $SSR_PORT
	
# -----------------------------------------------------------------------------
# Configure supervisor
# -----------------------------------------------------------------------------
ADD etc /etc/

EXPOSE $SVD_PORT

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"; "echo" "$ROOT_PASSWORD"]
