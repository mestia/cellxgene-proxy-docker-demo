FROM jgoerzen/debian-base-security:bookworm
MAINTAINER John Goerzen <jgoerzen@complete.org>

COPY setup/ /usr/local/debian-base-setup/
COPY cellxgene /srv/cellxgene
RUN cp -r /srv/cellxgene/etc/apache2/ /etc/apache2/
RUN cp -r /srv/cellxgene/var/www/ /var/www/
RUN /usr/local/debian-base-setup/040-debian-base-apache

ARG LDAPHOST=localhost
ENV ldaphost=$LDAPHOST
#RUN perl -i -pe "s/<LDAPHOST>/${LDAPHOST}/" /cellxgene/etc/cellxgene_templates/apache.conf
#RUN perl /srv/cellxgene/etc/cellxgene_templates/mkcellxgene_config.pl group01 /srv/cellxgene/etc/cellxgene_templates/

RUN a2enmod auth_form authnz_ldap headers proxy proxy_html proxy_http session_cookie session_crypto xml2enc rewrite ssl request
RUN echo LDAPVerifyServerCert Off >> /etc/apache2/mods-enabled/ldap.conf
RUN a2dissite 000-default
RUN a2ensite cellxgene

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/local/bin/boot-debian-base"]


EXPOSE 80
EXPOSE 443
