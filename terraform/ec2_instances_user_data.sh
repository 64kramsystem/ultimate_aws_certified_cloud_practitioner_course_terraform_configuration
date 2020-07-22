#!/bin/bash

set -o errexit

apt update
apt install --yes apache2

echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
