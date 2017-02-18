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
ENV ROOT_PASSWORD="passwd" \
	SSR_PASSWORD="passwd" \
	SSR_METHOD="rc4-md5" \
	SSR_PROTOCOL="auth_sha1_v4" \
	SSR_OBFS="tls1.2_ticket_auth"
	
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

#RUN cd && \
	git clone -b master https://github.com/snooda/net-speeder.git && \
	cd net-speeder/ && \
	sh build.sh && \
	cp -nf net_speeder /usr/bin/ && \
	cd && \
	rm -rf net-speeder/
	
# -----------------------------------------------------------------------------
# Configure ShadowsocksR
# -----------------------------------------------------------------------------
RUN cd && \
	git clone -b manyuser https://github.com/shadowsocksr/shadowsocksr.git && \
	cp -nf shadowsocksr/config.json shadowsocksr/shadowsocks/user-config.json
	
RUN sed -i \
	-e 's/"server_port".*/"server_port": 1000,/' \
	-e 's/"password".*/"password": "'$SSR_PASSWORD'",/' \
	-e 's/"method".*/"method": "'$SSR_METHOD'",/' \
	-e 's/"protocol".*/"protocol": "'$SSR_PROTOCOL'",/' \
	-e 's/"obfs".*/"obfs": "'$SSR_OBFS'",/' \
	/root/shadowsocksr/shadowsocks/user-config.json
	
EXPOSE 1000
	
# -----------------------------------------------------------------------------
# Configure supervisor
# -----------------------------------------------------------------------------
ADD etc/supervisord.conf /etc/
ADD etc/supervisord.d /etc/supervisord.d/

EXPOSE 1080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
