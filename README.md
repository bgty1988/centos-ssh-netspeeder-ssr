CentOS with SSH, NetSpeeder and SSR.

##### Environment Variables
- There are several environment variables defined at runtime these allow the operator to customise the running container.

###### SSHD
- **SSHD_PORT:** Set the listening port of SSHD (default 22);

###### ShadowsocksR
- **SSR_PORT:** Set the listening port of SSR (default 1000);
- **SSR_PASSWORD:** Set the password of SSR (default password);
- **SSR_METHOD:** See the [URL](https://github.com/breakwa11/shadowsocks-rss/wiki/obfs) for detail (default rc4-md5);
- **SSR_PROTOCOL:** See the [URL](https://github.com/breakwa11/shadowsocks-rss/wiki/obfs) for detail (default auth_sha1_v4);
- **SSR_OBFS:** See the [URL](https://github.com/breakwa11/shadowsocks-rss/wiki/obfs) for detail (default tls1.2_ticket_auth); 

###### Supervisor
- **SVD_PORT:** Set the listening port of HTTP server (default 1080);
- **SVD_USERNAME:** Set the user name used for login (default root);
- **SVD_PASSWORD:** Set the password used for login (default password);