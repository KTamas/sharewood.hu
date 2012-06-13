#!/usr/bin/env bash
git pull
bundle update
RAILS_ENV=production bundle exec rake assets:precompile
chmod -R 777 ./tmp/
killall nginx
sleep 10
/etc/init.d/nginx start
