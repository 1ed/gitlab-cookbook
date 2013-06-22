#
# Cookbook Name:: gitlab
# Recipe:: database
#
# Copyright (C) 2013 Gábor Egyed
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#
include_recipe "mysql::client"
include_recipe "mysql::server"
include_recipe "mysql::ruby"

# include the secure password from openssl recipe
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
# generate database password
node.set_unless[:gitlab][:database_config][:password] = secure_password
ruby_block "save node data" do
  block do
    node.save
  end
  not_if { Chef::Config[:solo] }
end

connection = {
    :host => "localhost",
    :username => "root",
    :password => node[:mysql][:server_root_password]
}

mysql_database node[:gitlab][:database_config][:database] do
  connection connection
  action :create
end

mysql_database_user node[:gitlab][:database_config][:username] do
  connection connection
  password node[:gitlab][:database_config][:password]
  database_name node[:gitlab][:database_config][:database]
  host "localhost"
  action [:create, :grant]
end
