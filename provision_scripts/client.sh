echo "192.168.33.33 master.minsk.epam.com master" >> /etc/hosts
echo "Adding puppetlabs repos..."
rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm &>/dev/null
echo "Done."
echo "installing puppet agent..."
yum install -y puppet-agent &>/dev/null
echo "Done"
#echo "server = master.minsk.epam.com" > /etc/puppetlabs/puppet/puppet.conf
echo "Applying configs..."
cp /tmp/configs/puppet.conf /etc/puppetlabs/puppet/
echo "Done."
source ~/.bashrc
#echo "Enabling puppet agent..."
#/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true &>/dev/null
#echo "Done."
echo "Executing: puppet agent -t..."
puppet agent -t
echo "Done."

echo "Apache availability check"
response_code=$(curl -s -o /dev/null -w "%{http_code}" http://client)
if [ $response_code == 200 ]; then echo Nginx is available; else echo Nginx is unavailalbe; fi

echo " -----------Puppet client is ready------------ "
