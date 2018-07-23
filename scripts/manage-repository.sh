#!/bin/sh
scrdir=$(dirname "$0")
command=$1
gpg-agent --daemon --batch --allow-preset-passphrase
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
        createrepo --verbose /miktex/repo
        rm -f /miktex/repo/repodata/repomd.xml.asc
        gpg2 --detach-sign --armor /miktex/repo/repodata/repomd.xml
        ;;
    *)
        echo "unknown command"
        exit 1
        ;;
esac
