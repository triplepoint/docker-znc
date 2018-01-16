#! /bin/bash

if [ ! -f "${znc_config_root}/znc.pem" ]; then
    /usr/local/bin/znc --datadir=$znc_config_root --makepem
fi

exec "$@"
