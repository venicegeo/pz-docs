#!/bin/sh

if [ "$PCF_DOMAIN" = "" ] ; then
    PCF_DOMAIN=stage.geointservices.io
fi
domain=$PCF_DOMAIN
