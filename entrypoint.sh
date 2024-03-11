#!/bin/sh

nginx -t
nginx

echo "****Running on http://0.0.0.0:80"

php-fpm