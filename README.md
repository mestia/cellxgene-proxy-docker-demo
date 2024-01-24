
# Table of Contents

1.  [Demo setup](#org8772b4e)
2.  [Running](#org1d6aa09)
3.  [Openldap](#org598dec3)
4.  [Apache2 reverse proxy](#org69a72a2)
5.  [cellxgene-gateway](#org7d25c22)


<a id="org8772b4e"></a>

# Demo setup

Easy to run demo setup of openldap, apache2 reverse proxy and cellxgene-gateway with cellxgene
Openldap container is optional, one can use an existing one for example.


<a id="org1d6aa09"></a>

# Running

Assuming that `docker` and `docker compose` are installed.

`make prepare` or just `make` suppose to download a demo file into `/tmp/cellxgene_data` and start 5 docker containers.

If everything went fine, one should be able to navgate to https://localhost:443 and see the proxy interface.

The users come from ldap, there are 3 users, `user1`, `user2` and `user3` with password `test1`
`user1` and `user2` have access to `/group1` and `/group2`

`make stop` will stop the container, `make clean` stop and remove

file group_mapping.txt contains mapping between a group and host:port of a cellxgene-gateway instance


<a id="org598dec3"></a>

# Openldap

Openldap is based on <https://github.com/osixia/docker-openldap>
See the docker-compose.yaml file for the environment vars and other config options

<a id="org69a72a2"></a>

# Apache2 reverse proxy

Based on <https://salsa.debian.org/mestia/docker-debian-base-apache>

Same, see the docker-compose for more details.

<a id="org7d25c22"></a>

# cellxgene-gateway

See the Dockerfile, uses python3.9 since cellxgene currently crashes with python3.11.

Added logout option for the better integration

