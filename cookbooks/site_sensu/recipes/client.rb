#
# Cookbook Name:: ora-sensu
# Recipe:: client 
#
# Copyright 2015, Ora
#
# All rights reserved - Do Not Redistribute
#

if node['recipes'].include?('site_sensu::server')
  server_address = 'localhost'
else
  server_address = node['site_sensu']['server_address']
end

node.override['sensu']['use_embedded_ruby'] = true
node.override['sensu']['rabbitmq']['host'] = server_address
node.override['sensu']['redis']['host'] = server_address
node.override['sensu']['api']['host'] = server_address

include_recipe "sensu::default"

sensu_gem 'sensu-plugins-cpu-checks' do
  version '0.0.3'
end

sensu_gem 'sensu-plugins-disk-checks' do
  version '1.0.2'
end

sensu_gem 'sensu-plugins-memory-checks' do
  version '0.0.7'
end

sensu_gem 'sensu-plugins-process-checks' do
  version '0.0.6'
end

sensu_gem 'sensu-plugins-sidekiq' do
  version '0.0.2'
end

sensu_client node['fqdn'] do
  address node['ipaddress']
  subscriptions node['opsworks']['instance']['layers'] + ["all"]
end

include_recipe "sensu::client_service"
