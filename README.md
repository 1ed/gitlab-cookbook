# gitlab cookbook

Installs and configures the [GitLab](https://github.com/gitlabhq/gitlabhq)
application for production environment.


# Requirements

The cookbook was tested on ubuntu server 12.04 and may not works on other systems.

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


# Author

Author:: Gábor Egyed (<egyed.gabor@mentha.hu>)
