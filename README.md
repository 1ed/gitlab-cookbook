# gitlab cookbook

Installs and configures the [GitLab](https://github.com/gitlabhq/gitlabhq)
application for production environment.

This version installs GitLab 5.3.

# Requirements

The cookbook was tested on ubuntu server (12.04, 13.04) and may not work on other systems.

Requires Chef 10.16.4 or later.


# Usage

If you want the full stack be handled by the cookbook just add the `default`
recipe to your run list:

    { "run_list": ["recipe[gitlab]"] }

If you want to customize some parts, e.g. use percona or postgres instead of mysql
just add individual recipes to the run list and replace some of your own:

    { "run_list": [
        "recipe[gitlab::base]",
        "recipe[gitlab::redis]",
        "recipe[your_cookbook::your_database_recipe]",
        "recipe[gitlab::shell]",
        "recipe[gitlab::app]",
        "recipe[gitlab::web]"
    ] }

# Attributes

See [`attributes/default.rb`](attributes/default.rb) for more information.


# Recipes

## default

Installs the full stack.

## base

Installs dependencies and setup a user.

## database

Installs mysql and setup a database.

## redis

Installs redis server from a ppa repository.

## shell

Setup gitlab-shell.

## app

Installs the gitlab application and setup the gitlab service.

## web

Installs nginx web server and a gitlab virtualhost to serve the app.


# Install GitLab to a remote server after a fresh OS installation (for Chef newbies)

    # create an empty directory
    mkdir git-server && cd git-server

    bundle init
    # edit the Gemfile
    vim Gemfile

      source "https://rubygems.org"

      gem 'berkshelf'
      gem 'knife-solo',
        :github => 'matschaffer/knife-solo',
        :branch => 'master',
        :submodules => true

    # install gems
    bundle install

    # create a new chef project
    bundle exec knife solo init --berkshelf .

    # edit the Berksfile
    vim Berksfile

      site :opscode

      cookbook "apt", "~> 2.0.0"
      cookbook "ntp", "~> 1.3.2"
      cookbook "postfix", "~> 2.1.6"
      cookbook "python", github: "opscode-cookbooks/python"
      cookbook "gitlab", github: "1ed/gitlab-cookbook"

    # install chef on the remote host (needs sudo)
    bundle exec knife solo prepare user@hostname

    # the previous command created a nodefile to the node direcotry
    # edit the nodefile, use your own passwords, hostnames, smtp config, ...
    # gitlab admin password must be at least 6 characters long
    vim node/hostname.json

      {
        "mysql": {
          "bind_address": "127.0.0.1",
          "server_root_password": "rootpass",
          "server_debian_password": "debpass",
          "server_repl_password": "replpass"
        },
        "gitlab": {
          "host": "git.example.com",
          "admin": {
            "email": "admin@git.example.com",
            "name": "Administrator",
            "username": "admin",
            "password": "adminadmin"
          },
          "database_config": {
            "password": "gitlabdbpass"
          }
        },
        "postfix": {
          "smtp_tls_cafile": "/etc/ssl/certs/ca-certificates.crt",
          "myhostname": "git.example.com",
          "relayhost": "[smtp.example.com]:587",
          "smtpd_use_tls": "no",
          "smtp_sasl_auth_enable": "yes",
          "smtp_sasl_user_name": "smtp_user@example.com",
          "smtp_sasl_passwd": "smtp_password"
        },
        "nginx": {
          "default_site_enabled": false
        },
        "run_list": [
          "recipe[apt]",
          "recipe[ntp]",
          "recipe[postfix]",
          "recipe[postfix::sasl_auth]",
          "recipe[python]",
          "recipe[gitlab]"
        ]
      }

    # cook :)
    bundle exec knife solo cook user@hostname

    # go to git.example.com and login with admin/adminadmin


# Author

Author:: Gábor Egyed (<egyed.gabor@mentha.hu>)
