#! /bin/sh

container_base=$(basename $(pwd) | tr '[:upper:]' '[:lower:]');
service_name="$container_base-workspace-1";
branch_name=${1:="main"};

git pull origin $branch_name;

chmod +x ./deploy-prod.sh;

docker compose down

docker compose -f docker-compose.prod.yaml down 1>/dev/null;

rsync -aI --exclude-from='.php-fpm.rsync_ignore' ./dev/php-fpm/project/ ./prod/php-fpm/project/;

chmod -R a+wr ./prod/

docker compose -f docker-compose.prod.yaml up -d --build 1>/dev/null;

docker exec $service_name mkdir -p ./prod/php-fpm/project/storage/ 1>/dev/null;
docker exec $service_name mkdir -p ./prod/php-fpm/project/vendor/ 1>/dev/null;
docker exec $service_name mkdir -p ./prod/php-fpm/project/node_modules/ 1>/dev/null;

APP_KEY=$(cat ./prod/php-fpm/project/.env | grep APP_KEY |  cut -d "=" -f 2)

if [ -z "$APP_KEY" ]; then
    docker exec $service_name php artisan key:generate 1>/dev/null;
fi

docker exec $service_name composer install 1> /dev/null
docker exec $service_name npm install 1>/dev/null;