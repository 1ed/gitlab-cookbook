#
# Cookbook Name:: gitlab
# Recipe:: backup
#
# Copyright (C) 2013 Gábor Egyed
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

directory node[:gitlab][:backup_path] do
  owner node[:gitlab][:user]
  group node[:gitlab][:user]
  mode 00700
  action :create
  only_if { node[:gitlab][:make_backups] }
end

include_recipe "cron"

cron_d "gitlab-backup" do
  action node[:gitlab][:make_backups] ? :create : :delete
  hour "4"
  minute "0"
  user node[:gitlab][:user]
  home node[:gitlab][:app_home]
  command %Q{
    cd #{node[:gitlab][:app_home]} &&
    bundle exec rake gitlab:backup:create RAILS_ENV=production
  }
end
