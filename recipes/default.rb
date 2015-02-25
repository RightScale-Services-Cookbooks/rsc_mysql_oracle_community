#
# Cookbook Name:: rsc_mysql_oracle_community
# Recipe:: default
#
# Copyright (C) 2014 RightScale Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
marker "recipe_start_rightscale" do
  template "rightscale_audit_entry.erb"
end

case node["platform_family"]
when "debian"
  raise "unsupported"
when "rhel"
  case node["platform_version"].split(".").first
  when "6"
    rpm_url="http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm"
  when "7"
    rpm_url="http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm"
  end

  include_recipe "yum"

  execute "create-yum-cache" do
    command "yum -q makecache"
    action :nothing
  end

  ruby_block "reload-internal-yum-cache" do
    block do
      Chef::Provider::Package::Yum::YumCache.instance.reload
    end
    action :nothing
  end

  p = rpm_package "#{Chef::Config[:file_cache_path]}/mysql-community-release-el.noarch.rpm" do
    action :nothing
    notifies :run, "execute[create-yum-cache]", :immediately
    notifies :create, "ruby_block[reload-internal-yum-cache]", :immediately
  end

  r = remote_file "#{Chef::Config[:file_cache_path]}/mysql-community-release-el.noarch.rpm" do
    source rpm_url
    owner "root"
    group "root"
    mode 0644
    #notifies :install, "rpm_package[/tmp/mysql-community-release-el.noarch.rpm]", :immediately
    action :nothing
  end
  r.run_action(:create)
  p.run_action(:install)
end

Chef::Log.info "Service_name: #{node['mysql']['server']['service_name']}"
