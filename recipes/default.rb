#
# Cookbook Name:: gitlab
# Recipe:: default
#
# Copyright (C) 2013 Gábor Egyed
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

include_recipe "gitlab::base"
include_recipe "gitlab::redis"
include_recipe "gitlab::database"
include_recipe "gitlab::shell"
include_recipe "gitlab::app"
include_recipe "gitlab::web"
