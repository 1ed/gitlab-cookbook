#
# Cookbook Name:: gitlab
# Recipe:: logrotate
#
# Copyright (C) 2013 Gábor Egyed
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

logrotate_app 'gitlab' do
  cookbook  'logrotate'
  path      ["#{node[:gitlab][:app_home]}/log/*.log", "#{node[:gitlab_shell][:app_home]}/gitlab-shell.log"]
  rotate    52
  frequency 'weekly'
  options   ['missingok', 'delaycompress', 'notifempty', 'copytruncate']
end
