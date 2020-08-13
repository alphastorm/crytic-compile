#!/usr/bin/env bash

### Test dapp integration

mkdir /tmp/dapp
cd /tmp/dapp
# The dapp init process makes a temporary local git repo and needs certain values to be set
git config --global user.email "ci@trailofbits.com"
git config --global user.name "CI User"


curl https://nixos.org/nix/install | sudo sh
# shellcheck disable=SC1090
. "$HOME/.nix-profile/etc/profile.d/nix.sh"
nix-env -iA nixpkgs.cachix
cachix use dapp

git clone --recursive https://github.com/dapphub/dapptools "$HOME/.dapp/dapptools"
nix-env -f "$HOME/.dapp/dapptools" -iA dapp seth solc hevm ethsign

dapp init

crytic-compile . --compile-remove-metadata
if [ $? -ne 0 ]
then
    echo "dapp test failed"
    exit -1
fi
# TODO: for some reason dapp output is not deterministc

#cd -
#
#DIFF=$(diff /tmp/dapp/crytic-export/contracts.json tests/expected/dapp-demo.json)
#if [ "$DIFF" != "" ]
#then
#    echo "Dapp test failed"
#    echo $DIFF
#    exit -1
#fi
#
