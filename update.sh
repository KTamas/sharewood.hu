#!/usr/bin/env bash
cd /web/sharewood.hu
echo "$(date)" >> /web/sharewood.hu/updatelog.txt
RAILS_ENV=production bundle exec rake utils:populate_feeds >> /web/sharewood.hu/updatelog.txt
