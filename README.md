
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

Assuming that docker and docker compose are installed, the following options are available:

1. Execute the command `make prepare` or simply `make` to download a demo file into the directory `/tmp/cellxgene_data` and initiate all containers.
2. To run the container in the background, utilize the command "make run".
3. If the above steps were successful, the user should be able to access the proxy interface by navigating to the URL https://localhost:443
4. The user authentication is managed through LDAP, three users are available: user1, user2, and user3. Their passwords are set as "test1". Both user1 and user2 have access to the directories /group1 and /group2 correspondignly.
5. To stop the container, enter the command `make stop`. `make clean` will stop and remove containers altogether.
6. The file named "group_mapping.txt" contains a mapping between a group and the corresponding host and port of a cellxgene-gateway instances.

<a id="org598dec3"></a>

# OpenLDAP

Openldap is based on <https://github.com/osixia/docker-openldap>
See the docker-compose.yaml file for the environment vars and other config options

## LDAP access/modification

Remote access to the config `ldapvi --tls never -h  ldaps://localhost:636 -b cn=config -D cn=admin,cn=config`
password `config` , is set as docker-compose env var.

Dumping ldap db:

`docker exec -it  openldap-local slapcat`

Access to the working db:

`ldapvi --tls never -h  ldaps://localhost:636 -b dc=blackmesa,dc=gov  -D cn=admin,dc=blackmesa,dc=gov`

Anonymous access: `ldapsearch  -LLL -x -H ldaps://localhost:636 -b dc=blackmesa,dc=gov`


<a id="org69a72a2"></a>

# Apache2 reverse proxy

Based on <https://salsa.debian.org/mestia/docker-debian-base-apache>

scripts for generating apache configs are located in cellxgene directory, modified fork of
the initial example: https://github.com/mestia/cellxgene-gateway-proxy-example

See the docker-compose for more details.

## If running on a remote machine, ssh port forwaring

Through a management host:
`ssh -L 4443:<remote_machine with docker>:443  me@my_machine`

Directly: `ssh -L 4443:localhost:443  root@server `

Navigating on https://localhost:4443 suppose to bring the proxy interface. Of course one would need to accept the self-signed snakeoil cert.

<a id="org7d25c22"></a>

# cellxgene-gateway

See the Dockerfile, uses python3.9 since cellxgene currently crashes with python3.11.

Added logout option for the better integration

# Bugs

Due to the utilization of session cookies, a situation can arise where a valid user enters a correct user/password combination belonging to a group that lacks access permissions to the resource due to the ldap configuration. Despite this, the session cookie is still established, leading to subsequent unsuccessful login attempts by the correct user. If this occurs, the recommended course of action is to navigate to the root of the site and select the "Logout from All Sessions" option. Following this, logging in with the correct user will function as expected.
