# Docker image for managing a MiKTeX-specific local RPM package repository

## Obtaining the image

Get the latest image from the registry:

    docker pull miktex/miktex-repo-rpm

or build it yourself:

    docker build --tag miktex/miktex-repo-rpm .

## Using the image

### Prerequisites

1. The directory containing the unsigned `.rpm` file(s) must be
   mounted to the container path `/miktex/rpms`.

2. The secret key file for GPG signing must be mounted to the
   container path `/miktex/signing.sec`.

3. The name of the key owner must be passed in the environment
   variable `MIKTEX_SIGNER`.

4. The passphrase for the signing key can be stored in the container
   environment variable `MIKTEX_PASSPHRASE` or in the container file
   `/miktex/passphrase`.  This step is optional.  If you don't write
   the passphrase to `MIKTEX_PASSPHRASE` or `/miktex/passphrase`, then
   you will be prompted to enter it when GPG signs the release.

5. The keygrip of the secret key must be passed in the environment
   variable `MIKTEX_KEYGRIP`.

6. These arguments must be supplied for the container entrypoint:
   1. `/miktex/manage-repository.sh`
   2. the command to execute; one of: `add`

7. The repository is managed with the help of `createrepo`.  The
   repository root directory must be mounted to the container path
   `/miktex/repo`.

You should specify a user by setting the container environment
variables `USER_ID` and `GROUP_ID`.

### Example

Create a repository containing MiKTeX `.rpm` packages for Fedora 28.

    mkdir -p ~/work/miktex/fc28
    # create .rpm files in ~/work/miktex/fc28
    gpg --export-secret-keys > /tmp/shred.me
    mkdir -p ~/work/miktex/aptly
    docker run --rm -t \
      -v ~/work/miktex/fc28:/miktex/rpms:ro \
      -v /tmp/shred.me:/miktex/signing.sec:ro \
      -v ~/work/miktex/repo:/miktex/repo:rw \
      -e "MIKTEX_SIGNER=Donald Duck" \
      -e "MIKTEX_KEYGRIP=9BBBFFBA432BD13D1DF8C7E81E1A17B0D4E34D62 \
      -e USER_ID=`id -u` \
      -e GROUP_ID=`id -g` \
      miktex/miktex-repo-rpm \
      /miktex/manage-repository.sh add
    shred -u /tmp/shred.me
