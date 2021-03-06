#
# Cookbook Name:: gitlab
# Recipe:: app
#
# Copyright (C) 2013 Gábor Egyed
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

Chef::Application.fatal!(
  "gitlab admin user password must be at least 6 characters long"
) if node[:gitlab][:admin][:password].length < 6

# git clone
git node[:gitlab][:app_home] do
  repository node[:gitlab][:git_url]
  reference node[:gitlab][:git_ref]
  user node[:gitlab][:user]
  group node[:gitlab][:user]
end

# create dirs
directory node[:gitlab][:satellites_home] do
  owner node[:gitlab][:user]
  group node[:gitlab][:user]
  mode 00700
  action :create
end

%w{ tmp/sockets tmp/pids public/uploads }.each do |dir|
  directory "#{node[:gitlab][:app_home]}/#{dir}" do
    user node[:gitlab][:user]
    group node[:gitlab][:user]
    mode 00755
    recursive true
    action :create
  end
end

# define gitlab service
service "gitlab" do
  priority 99
  supports :status => true, :restart => true
end

# render templates
template "#{node[:gitlab][:user_home]}/.gitconfig" do
  source "gitconfig.erb"
  owner node[:gitlab][:user]
  group node[:gitlab][:user]
  mode 00644
end

template "#{node[:gitlab][:app_home]}/config/database.yml" do
  source "database.yml.erb"
  owner node[:gitlab][:user]
  group node[:gitlab][:user]
  mode 0600
  notifies :restart, "service[gitlab]"
end

template "#{node[:gitlab][:app_home]}/config/gitlab.yml" do
  source "gitlab.yml.erb"
  owner node[:gitlab][:user]
  group node[:gitlab][:user]
  mode 0600
  notifies :restart, "service[gitlab]"
end

template "#{node[:gitlab][:app_home]}/config/resque.yml" do
  source "resque.yml.erb"
  owner node[:gitlab][:user]
  group node[:gitlab][:user]
  mode 0600
  notifies :restart, "service[gitlab]"
end

template "#{node[:gitlab][:app_home]}/config/unicorn.rb" do
  source "unicorn.rb.erb"
  owner node[:gitlab][:user]
  group node[:gitlab][:user]
  mode 0600
  notifies :restart, "service[gitlab]"
end

template "#{node[:gitlab][:app_home]}/db/fixtures/production/001_admin.rb" do
  source "admin_fixture.yml.erb"
  owner node[:gitlab][:user]
  group node[:gitlab][:user]
  mode 0600
end

# enable rack-attack
execute "gitlab-enable-rack-attack" do
  command "sed -i 's/# config.middleware.use Rack::Attack/config.middleware.use Rack::Attack/' config/application.rb"
  cwd node[:gitlab][:app_home]
  user node[:gitlab][:user]
  group node[:gitlab][:user]
  action :nothing
end

template "#{node[:gitlab][:app_home]}/config/initializers/rack_attack.rb" do
  source "rack_attack.rb.erb"
  owner node[:gitlab][:user]
  group node[:gitlab][:user]
  mode 0644
  notifies :run, "execute[gitlab-enable-rack-attack]", :immediately
end

# install bundles
execute "gitlab-bundle-install" do
  command "bundle install --binstubs --deployment --without development test postgres && git rev-parse HEAD > .gitlab-revision"
  cwd node[:gitlab][:app_home]
  user node[:gitlab][:user]
  group node[:gitlab][:user]
  environment({ 'LANG' => "en_US.UTF-8", 'LC_ALL' => "en_US.UTF-8", 'HOME' => node[:gitlab][:user_home] })
  not_if "grep -qi $(git rev-parse HEAD) .gitlab-revision", :cwd => node[:gitlab][:app_home], :user => node[:gitlab][:user]
  notifies :run, "execute[gitlab-setup]", :immediately
  notifies :run, "execute[gitlab-migrate]", :immediately
  notifies :restart, "service[gitlab]"
end

# setup database
execute "gitlab-setup" do
  command "bundle exec rake gitlab:setup RAILS_ENV=production force=yes && touch .gitlab-setup"
  cwd node[:gitlab][:app_home]
  user node[:gitlab][:user]
  group node[:gitlab][:user]
  action :nothing
  not_if { File.exists?("#{node[:gitlab][:app_home]}/.gitlab-setup") }
end

execute "gitlab-migrate" do
  command "bundle exec rake db:migrate RAILS_ENV=production"
  cwd node[:gitlab][:app_home]
  user node[:gitlab][:user]
  group node[:gitlab][:user]
  action :nothing
  only_if { File.exists?("#{node[:gitlab][:app_home]}/.gitlab-setup") }
end

# render gitlab init script
template "/etc/init.d/gitlab" do
  source "init.erb"
  owner "root"
  group "root"
  mode 00755
  notifies :enable, "service[gitlab]"
  notifies :restart, "service[gitlab]"
end
