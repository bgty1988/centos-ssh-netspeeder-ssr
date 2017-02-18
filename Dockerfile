# =============================================================================
# shijh666/centos-ssh
#
# CentOS latest - SSH / SSR / Net Speeder.
#
# =============================================================================

FROM centos:latest

MAINTAINER shijh666

# -----------------------------------------------------------------------------
# Install necessary packages
# -----------------------------------------------------------------------------

RUN yum update -y && \
	yum install -y \
		openssh-server \
		openssh-clients \
		python-setuptools \
		git && \
	yum clean all
		
# -----------------------------------------------------------------------------
# Configure SSH
# -----------------------------------------------------------------------------

RUN sed -i \
	-e 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' \
	-e 's/^#\?UsePAM yes/UsePAM no/g' \
	/etc/ssh/sshd_config

RUN echo "root:${ROOT_PASSWORD:-passwd}" | chpasswd

EXPOSE 22

# -----------------------------------------------------------------------------
# Install supervisor
# -----------------------------------------------------------------------------

RUN easy_install supervisor

# -----------------------------------------------------------------------------
# Copy files into place
# -----------------------------------------------------------------------------

CMD ["/usr/sbin/sshd", "-D"]
