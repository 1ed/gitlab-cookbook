#
# Cookbook Name:: gitlab
# Recipe:: shell
#
# Copyright (C) 2013 Gábor Egyed
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

# git clone
git node[:gitlab_shell][:app_home] do
  repository node[:gitlab_shell][:git_url]
  reference node[:gitlab_shell][:git_ref]
  user node[:gitlab][:user]
  group node[:gitlab][:user]
end

# render gitlab shell config file
template "#{node[:gitlab_shell][:app_home]}/config.yml" do
  source "shell_config.yml.erb"
  user node[:gitlab][:user]
  group node[:gitlab][:user]
  mode 0600
end

# run install script
execute "install gitlab-shell" do
  command "bin/install"
  user node[:gitlab][:user]
  group node[:gitlab][:user]
  cwd node[:gitlab_shell][:app_home]
  creates "#{node[:gitlab_shell][:repositories]}"
end
