# docker-oracle-xe-10g

Oracle Express Edition Universal 10g Release 2 (10.2.0.1) 32-bit on Debian.

Based on
[chameleon82/docker-oracle-xe-10g](https://github.com/chameleon82/docker-oracle-xe-10g).

### Build

```
docker build -t jaanonim/docker-oracle-xe-10g .
```

### Installation

```
docker pull jaanonim/docker-oracle-xe-10g
```

Run with 8080 port opened:

```
docker run -d -p 8080:8080 --mount source=oracle_xe_10g_vol,target=/usr/lib/oracle jaanonim/docker-oracle-xe-10g
```

Login to web administrator on a browser:

```
http://localhost:8080/apex
```
