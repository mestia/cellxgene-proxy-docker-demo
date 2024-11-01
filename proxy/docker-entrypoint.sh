#!/bin/sh
set -x

# Replace any environment variable references in apache.conf.
envsubst <"/srv/cellxgene/etc/cellxgene_templates/apache.conf" >"/srv/cellxgene/etc/cellxgene_templates/apache.conf.1"
mv /srv/cellxgene/etc/cellxgene_templates/apache.conf.1 /srv/cellxgene/etc/cellxgene_templates/apache.conf

#generate apache configs for every group defined in group_host_mapping
for group in  $(awk -F\: '!/^#/ {print $1}' /srv/cellxgene/etc/cellxgene_templates/group_host_mapping); do
	perl /srv/cellxgene/etc/cellxgene_templates/mkcellxgene_config.pl $group /srv/cellxgene/etc/cellxgene_templates/
done
# fix permissions:
find /srv/cellxgene/var -type d -exec chmod 755 '{}' \;
find /srv/cellxgene/var -type f -exec chmod 644 '{}' \;

# Run the standard container command.
exec "$@"
