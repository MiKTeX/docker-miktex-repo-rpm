gpg --batch --import /miktex/signing.sec
if [ ! -z "$MIKTEX_PASSPHRASE" ]; then
    echo "$MIKTEX_PASSPHRASE" | /usr/libexec/gpg-preset-passphrase --verbose --preset "$MIKTEX_KEYGRIP"
elif [ -f /miktex/passphrase ]; then
    cat /miktex/passphrase | /usr/libexec/gpg-preset-passphrase --verbose --preset "$MIKTEX_KEYGRIP"
else
    echo "warning: no passphrase"
fi
