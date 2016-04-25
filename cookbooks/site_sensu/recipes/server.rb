#
# Cookbook Name:: ora-sensu
# Recipe:: server
#
# Copyright 2015, Ora
#
# All rights reserved - Do Not Redistribute
#
#

include_recipe "sensu::default"
include_recipe "sensu::rabbitmq"
include_recipe "sensu::redis"
include_recipe "sensu::server_service"
include_recipe "sensu::api_service"
include_recipe "uchiwa"

sensu_gem 'sensu-plugins-slack' do
  version '0.0.4'
end

sensu_gem 'sensu-plugins-aws' do
  version '1.2.0'
end

sensu_check "check-cpu" do
  command "check-cpu.rb"
  handlers ["default"]
  subscribers ["all"]
  additional(:occurrences => 5)
  interval 60
end

sensu_check "check-disk-usage" do
  command "check-disk-usage.rb"
  handlers ["default"]
  subscribers ["all"]
  additional(:occurrences => 3)
  interval 60
end

sensu_check "check-ram" do
  command "check-ram.rb"
  handlers ["default"]
  subscribers ["all"]
  additional(:occurrences => 3)
  interval 60
end

sensu_check "check-apache-process" do
  command "check-process.rb -p apache2"
  handlers ["default"]
  subscribers ["rails-app"]
  additional(:occurrences => 3)
  interval 60
end

sensu_check "check-sidekiq" do
  command "check-sidekiq.rb -u http://localhost/sidekiq/monitor-stats"
  handlers ["default"]
  subscribers ["rails-app"]
  interval 60
end

sensu_handler "default" do
  type "set"
  handlers ["slack", "sns"]
end

sensu_handler "slack" do
  type "pipe"
  command "handler-slack.rb"
  severities ["ok", "warning", "critical"]
end

sensu_handler "sns" do
  type "pipe"
  command "handler-sns.rb"
  severities ["ok", "critical"]
end

sensu_snippet "slack" do
  content(:webhook_url => node.default['site_sensu']['slack']['webhook_url'],
          :channel     => node.default['site_sensu']['slack']['channel'],
          :bot_name    => node.default['site_sensu']['slack']['bot_name'])
end

sensu_snippet "sns" do
  content(:topic_arn   => node['site_sensu']['sns']['topic_arn'],
          :region      => node['site_sensu']['sns']['region'])
end
