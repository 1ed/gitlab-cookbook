#
# Cookbook Name:: gitlab
# Recipe:: redis
#
# Copyright (C) 2013 Gábor Egyed
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

apt_repository "rwky-redis" do
  uri          "http://ppa.launchpad.net/rwky/redis/ubuntu"
  distribution node['lsb']['codename']
  components   ["main"]
  keyserver    "keyserver.ubuntu.com"
  key          "5862E31D"
end

package "redis-server" do
  action :install
end

service "redis-server" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

node.set_unless[:gitlab_shell][:redis_config] = {
  :bin => "/usr/bin/redis-cli",
  :host => "127.0.0.1",
  :port => "6379",
  #:socket => "/var/run/redis/redis.sock",
  :namespace => "resque:gitlab"
}

node.set_unless[:gitlab][:redis_uri] = "redis://localhost:6379"
