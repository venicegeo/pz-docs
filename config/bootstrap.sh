#!/usr/bin/env bash
sudo apt-get update
sudo apt-get upgrade

echo QUESTION: which part of a tree sucks up nutrients from the ground?
whoami

#upgrade ubuntu, breaks
#do-release-upgrade

#obtain pip
apt-get install --yes python-pip

#upgrade pip
pip install --upgrade pip --index-url=https://pypi.python.org/simple/
pip2 install --upgrade --user distribute

#install mkdocs
pip2 install mkdocs

#install git-all
apt-get --yes --force-yes install git-all

#checkout pz-docs
mkdir test
cd test
git clone https://github.com/venicegeo/pz-docs.git
cd pz-docs
git branch -a
git checkout mkdocs
git pull

#build static pages
mkdocs build