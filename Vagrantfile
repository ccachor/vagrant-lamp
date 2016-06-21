Vagrant.configure("2") do |config|
  
  config.vm.provision "shell", inline: "echo Begin Provisioning"
  
  config.vm.define "web" do |web|
    dc.vm.box = "ubuntu/trusty64"
    dc.vm.hostname = "web"
    dc.vm.network :private_network, ip: '192.168.30.2'
    dc.vm.synced_folder "/Library/WebServer/Documents/example", "/var/www/html/"
    dc.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "1024"]
	end
    dc.vm.provision :shell, path: "web.sh"
  end
    
  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/trusty64"
    db.vm.hostname = "db"
    db.vm.network :private_network, ip: '192.168.30.4'
    db.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "1024"]
	end
    db.vm.provision :shell, path: "db.sh"
  end
  
end