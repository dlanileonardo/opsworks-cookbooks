#
# Cookbook Name:: git
# Recipe:: packages
#
# Copyright 2013, Bubble
#
include_recipe "apt"

node['php']['packages'].each do | pkg |
  package pkg do
    action :install
  end
end