echo "Adding puppetlabs repo..."
rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm &>/dev/null
echo "Done."

echo "Installing Puppetserver..."
yum install -y puppetserver &>/dev/null
systemctl enable puppetserver &>/dev/null
systemctl start puppetserver
echo "Done."


source ~/.bashrc

echo "Installing puppetlabs-mysql..."
puppet module install puppetlabs-mysql --version 3.10.0
echo "Done."

echo "Updating Hosts..."
echo "192.168.33.34 client.minsk.epam.com client" >> /etc/hosts
echo "192.168.33.33 master.minsk.epam.com client" >> /etc/hosts
echo "Done."

echo "Ensure that env prod is created..."
mkdir -p /etc/puppetlabs/code/environments/prod/{manifests,modules}
echo "Done."



echo "Postgre: Installing and configuring PostgreSQL..."
yum install -y http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-redhat94-9.4-2.noarch.rpm
yum install postgresql94-server postgresql94-contrib -y &>/dev/null
echo "Postgre: Installed."

echo "Postgre: Initializing db..."
/usr/pgsql-9.4/bin/postgresql94-setup initdb
echo "Done."

echo "Postgre: Enabling and Starting postgreservice..."
systemctl enable postgresql-9.4.service &>/dev/null
systemctl start postgresql-9.4.service
echo "Done."

echo "Postgre: Configuring Postgre"
sudo -u postgres psql -c "create user puppetdb password 'puppetdb'" &>/dev/null
sudo -u postgres psql -c "create database puppetdb owner puppetdb" &>/dev/null
echo "Done"
echo "Postgre: finished"

echo "Production: Installing additional modules for production env..."
echo "Production: puppetdb..."
puppet module install puppetlabs-puppetdb --version 5.1.2
echo "Installed."

echo "Production: Installing apache..."
puppet module install puppetlabs-apache --version 1.11.0
echo "Installed."

echo "Production: Installing puppetexplorer..."
puppet module install spotify-puppetexplorer --version 1.1.1
echo "Installed."
echo "Production modules installation has been finished."

echo "Prod: Installing additional modules for prod env..."
echo "Prod: Installing Mysql 3.10.0..."
puppet module install puppetlabs-mysql --version 3.10.0 --environment prod
echo "Installed."

echo "Prod: Installing Nginx..."
puppet module install puppet-nginx --version 0.6.0 --environment prod
echo "Installed."
echo "Prod modules installation has been finished."

echo "Applying configs..."
cp /tmp/configs/site.pp /etc/puppetlabs/code/environments/production/manifests/
cp /tmp/configs/autosign.conf /etc/puppetlabs/puppet/
cp /tmp/configs/puppet.conf.server /etc/puppetlabs/puppet/puppet.conf
cp /tmp/configs/site.pp.prod /etc/puppetlabs/code/environments/prod/manifests/site.pp
cp /tmp/configs/pg_hba.conf /var/lib/pgsql/9.4/data/
echo "Done."

echo "Restarting Puppetserver..."
systemctl restart puppetserver
echo "Done."

echo "Running puppet agent..."
puppet agent -t
echo "Agent finished."
service iptables stop

echo "Apache availability check"
response_code=$(curl -s -o /dev/null -w "%{http_code}" http://master)
if [ $response_code == 200 ]; then echo Apache is available; else echo Apache is unavailalbe; fi
echo " -----------Puppet master is ready------------ "
