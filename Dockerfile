# =============================================================================
# shijh666/centos-ssh
#
# CentOS 7.3.1611 x86_64 - SSH / SSR / Net Speeder.
#
# =============================================================================

FROM centos:7.3.1611

MAINTAINER shijh666

# -----------------------------------------------------------------------------
# Base Install + Import the RPM GPG keys for Repositories
# -----------------------------------------------------------------------------

RUN rpm --rebuilddb \
	&& rpm --import \
		http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 \
	&& rpm --import \
		https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 \
	&& rpm --import \
		https://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY \
	&& yum -y install \
		passwd \
		openssh-server \
		openssh-clients \
		screen \
		python-setuptools \
		git
		
# -----------------------------------------------------------------------------
# Configure SSH
# -----------------------------------------------------------------------------

RUN sed -i \
	-e 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' \
	/etc/ssh/sshd_config

RUN mkdir -p /root/.ssh/ \
	&& echo "StrictHostKeyChecking=no" > /root/.ssh/config \
	&& echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config

RUN echo "root:${ROOT_PASSWORD:-passwd}" | chpasswd

EXPOSE 22

# -----------------------------------------------------------------------------
# Install supervisor
# -----------------------------------------------------------------------------

RUN easy_install supervisor

# -----------------------------------------------------------------------------
# Copy files into place
# -----------------------------------------------------------------------------

CMD /usr/sbin/sshd -D
