#!/bin/bash -e

export DNS_SERVER=${DNS_SERVER:-$(cat /etc/resolv.conf |grep -i '^nameserver'|head -n1|cut -d ' ' -f2)}

ENV_VARIABLES=$(awk 'BEGIN{for(v in ENVIRON) print "$"v}')

FILES=(
    etc/nginx/nginx.conf
    etc/nginx/conf.d/default.conf
    etc/nginx/conf.d/tls.conf
    etc/modsecurity.d/modsecurity-override.conf
)

for FILE in ${FILES[*]}; do
    echo $FILE
    if [ -f $FILE ]; then
        envsubst "$ENV_VARIABLES" <$FILE | sponge $FILE
    fi
done

exec "$@"