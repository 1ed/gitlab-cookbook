#
# Cookbook Name:: gitlab
# Recipe:: web
#
# Copyright (C) 2013 Gábor Egyed
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

include_recipe "nginx::repo"
include_recipe "nginx"

# generate certificates
directory "/etc/nginx/certificates" do
  owner "root"
  group "root"
  mode 00700
  action :create
  only_if { node[:gitlab][:use_https] && !File.exists?(node[:gitlab][:ssl_certificate_pem]) }
end

bash "gitlab-create-SSL-certificate" do
  cwd "/etc/nginx/certificates"
  code <<-EOH
  umask 077
  openssl genrsa 2048 > #{node[:gitlab][:ssl_certificate_key]}
  openssl req -subj "#{node[:gitlab][:ssl_req]}" -new -x509 -nodes -sha1 -days 3650 -key #{node[:gitlab][:ssl_certificate_key]} > #{node[:gitlab][:ssl_certificate]}
  cat #{node[:gitlab][:ssl_certificate_key]} #{node[:gitlab][:ssl_certificate]} > #{node[:gitlab][:ssl_certificate_pem]}
  EOH
  not_if { !node[:gitlab][:use_https] || File.exists?(node[:gitlab][:ssl_certificate_pem]) }
end

# create vistualhost
template "/etc/nginx/sites-available/gitlab" do
  owner "root"
  group "root"
  mode 0644
  source "nginx_vhost.erb"
end

nginx_site "gitlab"
