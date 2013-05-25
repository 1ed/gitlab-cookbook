#
# Cookbook Name:: gitlab
# Recipe:: base
#
# Copyright (C) 2013 Gábor Egyed
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

# create user
user node[:gitlab][:user] do
  action :create
  home node[:gitlab][:user_home]
  system true
  supports :manage_home => true
end

# install required packages
node[:gitlab][:packages].each do |pkg|
  package pkg
end

# install pygments from pip
python_pip "pygments"

gem_package "bundler"

# insaltt the latest git (git >1.7.9 is requred by gitlab)
apt_repository "git" do
  uri "http://ppa.launchpad.net/git-core/ppa/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "E1DF1F24"
end

package "git" do
  action :upgrade
end
