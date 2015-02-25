site :opscode

metadata

cookbook 'collectd', github: 'rightscale-cookbooks-contrib/chef-collectd', branch: 'generalize_install_for_both_centos_and_ubuntu'
cookbook 'mysql', github: 'cdwilhelm/mysql', tag: '4.0.21'
cookbook 'dns', github: 'rightscale-cookbooks-contrib/dns', branch: 'rightscale_development_v2'
cookbook 'build-essential', '~> 1.4.4'
cookbook 'database', github: 'rightscale-cookbooks-contrib/database', branch: 'rs-fixes'
cookbook 'rs-mysql', github: 'rightscale-cookbooks/rs-mysql', tag:'v1.1.6'
group :integration do
  cookbook 'apt', '~> 2.3.0'
  cookbook 'yum-epel', '~> 0.4.0'
  cookbook 'curl', '~> 2.0.0'
  cookbook 'fake', path: './test/cookbooks/fake'
  cookbook 'rhsm', '~> 1.0.0'
end
