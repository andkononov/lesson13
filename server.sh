systemctl stop firewalld
      systemctl disable firewalld
      /bin/cp /vagrant/hosts /etc/
      yum install -y https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
      yum install -y http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-redhat94-9.4-2.noarch.rpm
      yum install -y puppetserver
      systemctl enable puppetserver
      /bin/cp /vagrant/site.pp /etc/puppetlabs/code/environments/production/manifests
      /bin/cp /vagrant/autosign.conf /etc/puppetlabs/puppet/
      /bin/cp /vagrant/puppet.conf.server /etc/puppetlabs/puppet/puppet.conf
      mkdir -p /etc/puppetlabs/code/environments/prod/{manifests,modules}
      /bin/cp /vagrant/site.pp.prod /etc/puppetlabs/code/environments/prod/manifests/site.pp
      systemctl restart puppetserver
      source ~/.bashrc
      yum install postgresql94-server postgresql94-contrib -y
      /usr/pgsql-9.4/bin/postgresql94-setup initdb
      yes | cp /vagrant/pg_hba.conf /var/lib/pgsql/9.4/data/
      systemctl enable postgresql-9.4.service
      systemctl start postgresql-9.4.service
      cd /
      sudo -u postgres psql -c "create user puppetdb password 'puppetdb'"
      sudo -u postgres psql -c "create database puppetdb owner puppetdb"
      puppet module install puppetlabs-puppetdb --version 5.1.2
      puppet module install puppetlabs-mysql --version 3.10.0 --environment prod
      puppet module install puppetlabs-apache --version 1.11.0
      puppet module install spotify-puppetexplorer --version 1.1.1
      puppet module install puppet-nginx --version 0.6.0 --environment prod
      systemctl restart network
