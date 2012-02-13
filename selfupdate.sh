#!/usr/bin/env bash
git pull
RAILS_ENV=production bundle exec rake assets:precompile
chmod -R 777 ./tmp/
/etc/init.d/nginx restart
