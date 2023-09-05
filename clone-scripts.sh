#!/bin/bash

# Copyright 2019 Tech Equity Cloud Services Ltd

if [[ $OSTYPE == 'darwin'* ]]; then
    brew install pv > /dev/null 2>&1 && brew install shc > /dev/null 2>&1
else
    sudo apt-get -y install pv shc > /dev/null 2>&1
fi
echo
echo "$ ssh-keygen -t ed25519 -C \"\$(gcloud config get-value core/account)\" # to generate a key" | pv -qL 100
ssh-keygen -t ed25519 -C "$(gcloud config get-value core/account)"
echo
echo "$ git config --global user.email \"\$(gcloud config get-value core/account)\" # to set email" | pv -qL 100
git config --global user.email "$(gcloud config get-value core/account)"
echo
echo "$ git config --global user.name \"Tech Equity\" # to set name" | pv -qL 100
git config --global user.name "Tech Equity"
echo
echo "$ git config --global init.defaultBranch main # to set default branch" | pv -qL 100
git config --global init.defaultBranch main
echo
echo "$ gh auth login # to authenticate" | pv -qL 100
gh auth login

echo
rm -rf /tmp/techequitydemo
echo "$ mkdir /tmp/techequitydemo # to create directory" | pv -qL 100
mkdir /tmp/techequitydemo

# List repositories in the organization, loop through and clone them
gh repo list techequitydemo --json=nameWithOwner -q ".[] | .nameWithOwner" | while read -r repo; do
    # script=${repo##*/}
    script=$(basename "$repo")
    echo
    echo "$ mkdir -p /tmp/techequitydemo/$script # to create repo directory" | pv -qL 100
    mkdir -p /tmp/techequitydemo/$script
    echo
    cd /tmp/techequitydemo/$script
    echo "$ git clone https://github.com/techequitydemo/$script.git /tmp/techequitydemo/$script # to clone repo" | pv -qL 100
    git clone https://github.com/techequitydemo/$script.git /tmp/techequitydemo/$script
    echo
    echo "$ mv /tmp/techequitydemo/$script $HOME # to move script to home directory" | pv -qL 100
    mv /tmp/techequitydemo/$script $HOME
    read -n 1 -s -r -p "$ "
done
echo
echo "*** Successfully cloned scripts ***"
echo
