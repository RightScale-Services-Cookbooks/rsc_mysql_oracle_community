name             'rsc_mysql_oracle_community'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures rsc_mysql_oracle_community'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'marker'
depends 'yum'
depends 'rs-mysql', '1.1.6'

recipe 'rsc_mysql_oracle_community::default', 'sets up mysql packages'
recipe 'rsc_mysql_oracle_community::master', 'Install Oracle MySQL Server Master Server'
recipe 'rsc_mysql_oracle_community::slave', 'Install Oracle MySQL Server Slave Server'
recipe 'rsc_mysql_oracle_community::volume', 'Creates a volume, attaches it to the server, and moves the MySQL data to the volume'
recipe 'rsc_mysql_oracle_community::stripe', 'Creates volumes, attaches them to the server, sets up a striped LVM, and moves the Percona' +
  ' data to the volume'

attribute 'rs-mysql/server_usage',
  :display_name => 'Server Usage',
  :description => "The Server Usage method. It is either 'dedicated' or 'shared'. In a 'dedicated' server all" +
  " server resources are dedicated to MySQL. In a 'shared' server, MySQL utilizes only half of the resources." +
  " Example: 'dedicated'",
  :default => 'dedicated',
  :required => 'optional',
  :recipes => ['rsc_mysql_oracle_community::default', 'rsc_mysql_oracle_community::master', 'rsc_mysql_oracle_community::slave']

attribute 'rs-mysql/bind_network_interface',
  :display_name => 'MySQL Bind Network Interface',
  :description => "The network interface to use for MySQL bind. It can be either" +
  " 'private' or 'public' interface.",
  :default => 'private',
  :choice => ['public', 'private'],
  :required => 'optional',
  :recipes => ['rsc_mysql_oracle_community::default', 'rsc_mysql_oracle_community::master', 'rsc_mysql_oracle_community::slave']

attribute 'rs-mysql/server_root_password',
  :display_name => 'MySQL Root Password',
  :description => 'The root password for MySQL server. Example: cred:MYSQL_ROOT_PASSWORD',
  :required => 'required',
  :recipes => ['rsc_mysql_oracle_community::default', 'rsc_mysql_oracle_community::master', 'rsc_mysql_oracle_community::slave']

attribute 'rs-mysql/application_username',
  :display_name => 'MySQL Application Username',
  :description => 'The username of the application user. Example: cred:MYSQL_APPLICATION_USERNAME',
  :required => 'optional',
  :recipes => ['rsc_mysql_oracle_community::default', 'rsc_mysql_oracle_community::master', 'rsc_mysql_oracle_community::slave']

attribute 'rs-mysql/application_password',
  :display_name => 'MySQL Application Password',
  :description => 'The password of the application user. Example: cred:MYSQL_APPLICATION_PASSWORD',
  :required => 'optional',
  :recipes => ['rsc_mysql_oracle_community::default', 'rsc_mysql_oracle_community::master', 'rsc_mysql_oracle_community::slave']

attribute 'rs-mysql/application_user_privileges',
  :display_name => 'MySQL Application User Privileges',
  :description => 'The privileges given to the application user. This can be an array of mysql privilege types.' +
  ' Example: select, update, insert',
  :required => 'optional',
  :type => 'array',
  :default => [:select, :update, :insert],
  :recipes => ['rsc_mysql_oracle_community::default', 'rsc_mysql_oracle_community::master', 'rsc_mysql_oracle_community::slave']

attribute 'rs-mysql/application_database_name',
  :display_name => 'MySQL Database Name',
  :description => 'The name of the application database. Example: mydb',
  :required => 'optional',
  :recipes => ['rsc_mysql_oracle_community::default', 'rsc_mysql_oracle_community::master', 'rsc_mysql_oracle_community::slave']

attribute 'rs-mysql/server_repl_password',
  :display_name => 'MySQL Slave Replication Password',
  :description => 'The replication password set on the master database and used by the slave to authenticate and' +
  ' connect. If not set, rs-mysql/server_root_password will be used. Example cred:MYSQL_REPLICATION_PASSWORD',
  :required => 'optional',
  :recipes => ['rsc_mysql_oracle_community::default', 'rsc_mysql_oracle_community::master', 'rsc_mysql_oracle_community::slave']

attribute 'rs-mysql/backup/lineage',
  :display_name => 'Backup Lineage',
  :description => 'The prefix that will be used to name/locate the backup of the MySQL database server.',
  :required => 'required',
  # :recipes => ['rsc_mysql_oracle_community::default', 'rsc_mysql_oracle_community::master', 'rsc_mysql_oracle_community::slave', 'rs-mysql::backup']
:recipes => ['rsc_mysql_oracle_community::default', 'rsc_mysql_oracle_community::master', 'rsc_mysql_oracle_community::slave']

attribute 'rs-mysql/dns/master_fqdn',
  :display_name => 'MySQL Database FQDN',
  :description => 'The fully qualified domain name of the MySQL master database server.',
  :required => 'optional',
  :recipes => ['rsc_mysql_oracle_community::master']

attribute 'rs-mysql/dns/user_key',
  :display_name => 'DNS User Key',
  :description => 'The user key to access/modify the DNS records.',
  :required => 'optional',
  :recipes => ['rsc_mysql_oracle_community::master']

attribute 'rs-mysql/dns/secret_key',
  :display_name => 'DNS Secret Key',
  :description => 'The secret key to access/modify the DNS records.',
  :required => 'optional',
  :recipes => ['rsc_mysql_oracle_community::master']

attribute 'rs-mysql/device/count',
  :display_name => 'Device Count',
  :description => 'The number of devices to create and use in the Logical Volume. If this value is set to more than' +
  ' 1, it will create the specified number of devices and create an LVM on the devices.',
  :default => '2',
  #:recipes => ['rsc_mysql_oracle_community::stripe', 'rs-mysql::decommission'],
:recipes => ['rsc_mysql_oracle_community::stripe'],
  :required => 'recommended'

attribute 'rs-mysql/device/mount_point',
  :display_name => 'Device Mount Point',
  :description => 'The mount point to mount the device on. Example: /mnt/storage',
  :default => '/mnt/storage',
 # :recipes => ['rsc_mysql_oracle_community::volume', 'rsc_mysql_oracle_community::stripe', 'rs-mysql::decommission'],
:recipes => ['rsc_mysql_oracle_community::volume', 'rsc_mysql_oracle_community::stripe',],
  :required => 'recommended'

attribute 'rs-mysql/device/nickname',
  :display_name => 'Device Nickname',
  :description => 'Nickname for the device. Example: data_storage',
  :default => 'data_storage',
 :recipes => ['rsc_mysql_oracle_community::volume', 'rsc_mysql_oracle_community::stripe'],
 # :recipes => ['rsc_mysql_oracle_community::volume', 'rsc_mysql_oracle_community::stripe', 'rs-mysql::decommission'],
  :required => 'recommended'

attribute 'rs-mysql/device/volume_size',
  :display_name => 'Device Volume Size',
  :description => 'Size of the volume or logical volume to create (in GB). Example: 10',
  :default => '10',
  :recipes => ['rsc_mysql_oracle_community::volume', 'rsc_mysql_oracle_community::stripe'],
  :required => 'recommended'

attribute 'rs-mysql/device/iops',
  :display_name => 'Device IOPS',
  :description => 'IO Operations Per Second to use for the device. Currently this value is only used on AWS clouds.' +
  ' Example: 100',
  :recipes => ['rsc_mysql_oracle_community::volume', 'rsc_mysql_oracle_community::stripe'],
  :required => 'optional'

attribute 'rs-mysql/device/volume_type',
  :display_name => 'Volume Type',
  :description => 'Volume Type to use for creating volumes. Example: gp2',
  :recipes => ['rsc_mysql_oracle_community::volume', 'rsc_mysql_oracle_community::stripe'],
  :required => 'optional'

attribute 'rs-mysql/device/filesystem',
  :display_name => 'Device Filesystem',
  :description => 'The filesystem to be used on the device. Example: ext4',
  :default => 'ext4',
  :recipes => ['rsc_mysql_oracle_community::volume', 'rsc_mysql_oracle_community::stripe'],
  :required => 'optional'

attribute 'rs-mysql/device/detach_timeout',
  :display_name => 'Detach Timeout',
  :description => 'Amount of time (in seconds) to wait for a single volume to detach at decommission. Example: 300',
  :default => '300',
  :recipes => ['rsc_mysql_oracle_community::volume', 'rsc_mysql_oracle_community::stripe'],
  :required => 'optional'

attribute 'rs-mysql/backup/lineage',
  :display_name => 'Backup Lineage',
  :description => 'The prefix that will be used to name/locate the backup of the MySQL database server.',
  :required => 'required',
 # :recipes => ['rs-mysql::default', 'rs-mysql::master', 'rs-mysql::slave', 'rs-mysql::backup']
 :recipes => ['rsc_mysql_oracle_community::default', 'rsc_mysql_oracle_community::master', 'rsc_mysql_oracle_community::slave']

attribute 'rs-mysql/restore/lineage',
  :display_name => 'Restore Lineage',
  :description => 'The lineage name to restore backups. Example: staging',
  :recipes => ['rsc_mysql_oracle_community::volume', 'rsc_mysql_oracle_community::stripe'],
  :required => 'recommended'

attribute 'rs-mysql/restore/timestamp',
  :display_name => 'Restore Timestamp',
  :description => 'The timestamp (in seconds since UNIX epoch) to select a backup to restore from.' +
  ' The backup selected will have been created on or before this timestamp. Example: 1391473172',
  :recipes => ['rsc_mysql_oracle_community::volume', 'rsc_mysql_oracle_community::stripe'],
  :required => 'recommended'
