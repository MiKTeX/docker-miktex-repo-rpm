#!/bin/sh
scrdir=$(dirname "$0")
command=$1
gpg-agent --daemon --allow-preset-passphrase
. "$scrdir/_set_passphrase.sh"
cat <<EOF >~/.rpmmacros
%_gpg_name ${MIKTEX_SIGNER}
EOF
case $command in
    add)
        for r in /miktex/rpms/*.rpm; do
            cp $r /miktex/repo
            rpm --addsign /miktex/repo/$(basename $r)
        done
        ;;
    *)
        echo "unknown command"
        exit 1
        ;;
esac
