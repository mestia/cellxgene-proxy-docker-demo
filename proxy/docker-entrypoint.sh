#!/bin/sh
set -x

# Replace any environment variable references in apache.conf.
envsubst <"/srv/cellxgene/etc/cellxgene_templates/apache.conf" >"/srv/cellxgene/etc/cellxgene_templates/apache.conf.1"
mv /srv/cellxgene/etc/cellxgene_templates/apache.conf.1 /srv/cellxgene/etc/cellxgene_templates/apache.conf
#perl -i -pe "s/<LDAPHOST>/${LDAPHOST}/" /cellxgene/etc/cellxgene_templates/apache.conf
for group in $CELLXGENE_GROUPS; do 
	perl /srv/cellxgene/etc/cellxgene_templates/mkcellxgene_config.pl $group /srv/cellxgene/etc/cellxgene_templates/
done

# Run the standard container command.
exec "$@"
