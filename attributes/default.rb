#
# Cookbook Name:: gitlab
# Attribute:: default
#
# Copyright (C) 2013 Gábor Egyed
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

# the hostname you want to access gitlab, e.g: git.yourcompany.com
default[:gitlab][:host] = node[:fqdn]
default[:gitlab][:user] = "git"
default[:gitlab][:user_home] = "/home/#{node[:gitlab][:user]}"
default[:gitlab][:packages] = %w{
  build-essential
  checkinstall
  curl
  libc6-dev
  libcurl4-openssl-dev
  libffi-dev
  libgdbm-dev
  libicu-dev
  libncurses5-dev
  libreadline-dev
  libssl-dev
  libxml2-dev
  libxslt1-dev
  libyaml-dev
  openssh-server
  openssl
  python-docutils
  ruby1.9.1-dev
  ruby1.9.3
  zlib1g-dev
}
default[:gitlab][:app_home] = "#{node[:gitlab][:user_home]}/gitlab"
default[:gitlab][:git_url] = "https://github.com/gitlabhq/gitlabhq.git"
default[:gitlab][:git_ref] = "6-2-stable"
default[:gitlab][:redis_uri] = nil
default[:gitlab][:database_config] = {
  :adapter => "mysql2",
  :encoding => "utf8",
  :reconnect => false,
  :pool => 10,
  :database => "gitlab",
  :username => "gitlab",
  :host => 'localhost',
  :socket => "/var/run/mysqld/mysqld.sock"
}
# this taken into account at the first run only
default[:gitlab][:admin] = {
  :email => "admin@local.host",
  :name => "Administrator",
  :username => "root",
  # password must be at least 6 chars long
  :password => "5iveL!fe"
}
default[:gitlab][:make_backups] = true
default[:gitlab][:backup_path] = "tmp/backups"
default[:gitlab][:backup_keep_time] = 604800 # 1 week
default[:gitlab][:satellites_home] = "#{node[:gitlab][:user_home]}/gitlab-satellites"
default[:gitlab][:use_https] = false
default[:gitlab][:ssl_certificate] = "/etc/nginx/#{node[:gitlab][:host]}.crt"
default[:gitlab][:ssl_certificate_key] = "/etc/nginx/#{node[:gitlab][:host]}.key"
default[:gitlab][:ssl_certificate_pem] = "/etc/nginx/#{node[:gitlab][:host]}.pem"
default[:gitlab][:ssl_req] = "/C=US/ST=Several/L=Locality/O=Example/OU=Operations/CN=#{node[:gitlab][:host]}/emailAddress=root@#{node[:gitlab][:host]}"

default[:gitlab_shell][:app_home] = "#{node[:gitlab][:user_home]}/gitlab-shell"
default[:gitlab_shell][:git_url] = "https://github.com/gitlabhq/gitlab-shell.git"
default[:gitlab_shell][:git_ref] = "v1.7.1"
default[:gitlab_shell][:repositories] = "#{node[:gitlab][:user_home]}/repositories"
default[:gitlab_shell][:redis_config] = nil
