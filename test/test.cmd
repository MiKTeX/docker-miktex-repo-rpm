if not exist %~dp0gnupg\nul (
  mkdir %~dp0gnupg
  gpg --homedir=%~dp0gnupg --gen-key
  gpg --homedir=%~dp0gnupg --export-secret-keys > %~dp0signing.sec
  gpg --with-keygrip --list-secret-keys
  echo please edit %0 and run it again
  exit /B 1
)
set command=%1
set signer=Donald Duck
set keygrip=9BBBFFBA432BD13D1DF8C7E81E1A17B0D4E34D62
set passphrase=test
docker run --rm -ti ^
  -v %~dp0rpms:/miktex/rpms:ro ^
  -v %~dp0signing.sec:/miktex/signing.sec:ro ^
  -v %~dp0repo:/miktex/repo:rw ^
  -e "MIKTEX_SIGNER=%signer%" ^
  -e "MIKTEX_KEYGRIP=%keygrip%" ^
  -e "MIKTEX_PASSPHRASE=%passphrase%" ^
  miktex/miktex-repo-rpm ^
  /miktex/manage-repository.sh %command%
