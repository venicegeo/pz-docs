#!/bin/sh
rm -rf vendor/
mkdir vendor

pip download -d vendor -r requirements.txt
