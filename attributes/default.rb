#
# Cookbook Name:: gitlab
# Attribute:: default
#
# Copyright (C) 2013 Gábor Egyed
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

default[:gitlab][:host] = node[:fqdn]
default[:gitlab][:user] = "git"
default[:gitlab][:user_home] = "/home/#{node[:gitlab][:user]}"
default[:gitlab][:packages] = %w{
  curl checkinstall ruby1.9.3 git-core openssh-server openssl
  build-essential ruby1.9.1-dev zlib1g-dev libyaml-dev libssl-dev
  libgdbm-dev libreadline-dev libncurses5-dev libffi-dev libxml2-dev
  libxslt1-dev libcurl4-openssl-dev libicu-dev libc6-dev
}
default[:gitlab][:app_home] = "#{node[:gitlab][:user_home]}/gitlab"
default[:gitlab][:git_url] = "https://github.com/gitlabhq/gitlabhq.git"
default[:gitlab][:git_ref] = "5-2-stable"
default[:gitlab][:redis_uri] = nil
default[:gitlab][:database_config] = {
  :adapter => "mysql2",
  :encoding => "utf8",
  :reconnect => false,
  :pool => 5,
  :database => "gitlab",
  :username => "gitlab",
  :host => 'localhost',
  :socket => "/var/run/mysqld/mysqld.sock"
}
default[:gitlab][:backup_path] = "tmp/backups"
default[:gitlab][:backup_keep_time] = 604800
default[:gitlab][:satellites_home] = "#{node[:gitlab][:user_home]}/gitlab-satellites"
default[:gitlab][:use_https] = false
default[:gitlab][:ssl_certificate] = "/etc/nginx/#{node[:gitlab][:host]}.crt"
default[:gitlab][:ssl_certificate_key] = "/etc/nginx/#{node[:gitlab][:host]}.key"
default[:gitlab][:ssl_certificate_pem] = "/etc/nginx/#{node[:gitlab][:host]}.pem"
default[:gitlab][:ssl_req] = "/C=US/ST=Several/L=Locality/O=Example/OU=Operations/CN=#{node[:gitlab][:host]}/emailAddress=root@#{node[:gitlab][:host]}"

default[:gitlab_shell][:app_home] = "#{node[:gitlab][:user_home]}/gitlab-shell"
default[:gitlab_shell][:git_url] = "https://github.com/gitlabhq/gitlab-shell.git"
default[:gitlab_shell][:git_ref] = "v1.4.0"
default[:gitlab_shell][:repositories] = "#{node[:gitlab][:user_home]}/repositories"
default[:gitlab_shell][:redis_config] = nil
#{
#  :bin => "/usr/local/bin/redis-cli",
#  :socket => "/var/run/redis/master/redis_master.sock",
#  :namespace => "resque:gitlab"
#}
