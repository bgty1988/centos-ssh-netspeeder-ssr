# centos-ssh-netspeeder-ssr
CentOS with SSH, NetSpeeder and SSR.

Environment Variables
There are several environment variables defined at runtime these allow the operator to customise the running container.

SSHD
	SSHD_PORT: listening port of SSHD, default 22;

ShadowsocksR
	SSR_PORT: listening port of SSR, default 1000;
	SSR_PASSWORD: password of SSR, default password;
	SSR_METHOD/SSR_PROTOCOL/SSR_OBFS: see the URL below for detail, default rc4-md5/auth_sha1_v4/tls1.2_ticket_auth;
		https://github.com/breakwa11/shadowsocks-rss/wiki/obfs

Supervisor
	SVD_PORT: listening port of HTTP server, default 1080;
	SVD_USERNAME: user name used for login, default root;
	SVD_PASSWORD: password used for login, default password;
	