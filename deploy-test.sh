#! /bin/sh

# git pull origin main;
rsync -av --exclude-from='.rsync_ignore' ./dev/php-fpm/project/ ./test/php-fpm/project/;
docker exec