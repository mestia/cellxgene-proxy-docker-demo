FROM jgoerzen/debian-base-security:bookworm
MAINTAINER John Goerzen <jgoerzen@complete.org>

COPY setup/ /usr/local/debian-base-setup/
COPY cellxgene /srv/cellxgene
RUN cp -r /srv/cellxgene/etc/apache2/ /etc/apache2/
RUN mkdir -p /etc/apache2/sites-available/cellxgene
RUN cp -r /srv/cellxgene/var/www/ /var/www/
RUN /usr/local/debian-base-setup/040-debian-base-apache

RUN a2enmod auth_form authnz_ldap headers proxy proxy_html proxy_http session_cookie session_crypto xml2enc rewrite ssl request
# we use self signed certs
RUN echo LDAPVerifyServerCert Off >> /etc/apache2/mods-enabled/ldap.conf
RUN a2dissite 000-default
RUN a2ensite cellxgene

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/local/bin/boot-debian-base"]


EXPOSE 80
EXPOSE 443
