# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

case node["platform_family"]
when "rhel"
  #client setting
node.override['mysql']['client']['packages'] = [ 'mysql-community-client', 'mysql-community-devel' ]

#server settings
node.override['mysql']['server']['packages'] = ['mysql-community-server','mysql-community-devel','mysql-community-libs','mysql-community-libs-compat']

node.force_override['mysql']['server']['service_name'] = 'mysqld'

when "debian"
#client setting
override['mysql']['client']['packages'] =[ 'mysql-community-client-5.6','libmysqlclient-dev']

#server settings
override['mysql']['server']['packages'] =['mysql-community-server-5.6']
end
override['mysql']['server']['service_name'] = 'mysql'
override['mysql']['version'] = '5.6'

override['mysql']['remove_test_database'] = "true" # remove test DB

# percona repository
#node.default['mysql']['percona']['apt_key_id'] = 'CD2EFD2A'
#node.default['mysql']['percona']['apt_uri'] = 'http://repo.percona.com/apt'
#node.default['mysql']['percona']['apt_keyserver'] = 'keys.gnupg.net'

node.default["percona"]["use_percona_repos"] = true
node.default["percona"]["apt_uri"] = "http://repo.percona.com/apt"
node.default["percona"]["apt_keyserver"] = "keys.gnupg.net"
node.default["percona"]["apt_key"] = "1C4CBDCDCD2EFD2A"
#
arch = node["kernel"]["machine"] == "x86_64" ? "x86_64" : "i386"
pversion = node["platform_version"].to_i

node.default["percona"]["yum"]["description"] = "Percona Packages"
node.default["percona"]["yum"]["baseurl"] = "http://repo.percona.com/centos/#{pversion}/os/#{arch}/"
node.default["percona"]["yum"]["gpgkey"] = "http://www.percona.com/downloads/RPM-GPG-KEY-percona"
node.default["percona"]["yum"]["gpgcheck"] = true
node.default["percona"]["yum"]["sslverify"] = true
