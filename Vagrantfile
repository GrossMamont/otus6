# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['HOME']
ENV["LC_ALL"] = "en_US.UTF-8"

MACHINES = {
  :lvm => {
        :box_name => "centos/7",
        :box_version => "1804.02",
        :ip_addr => '192.168.56.101',
    :disks => {
        :sata1 => {
            :dfile => home + '/VirtualBox VMs/sata1.vdi',
            :size => 10240,
            :port => 1
        },
        :sata2 => {
            :dfile => home + '/VirtualBox VMs/sata2.vdi',
            :size => 2048, # Megabytes
            :port => 2
        },
        :sata3 => {
            :dfile => home + '/VirtualBox VMs/sata3.vdi',
            :size => 1024, # Megabytes
            :port => 3
        },
        :sata4 => {
            :dfile => home + '/VirtualBox VMs/sata4.vdi',
            :size => 1024,
            :port => 4
        }
    }
  },
}

Vagrant.configure("2") do |config|

    config.vm.box_version = "1804.02"
    config.vm.allow_fstab_modification = false
    MACHINES.each do |boxname, boxconfig|
      config.vm.synced_folder ".", "/vagrant", disabled: true
  
        config.vm.define boxname do |box|
            #box.cpus = 4
  
            box.vm.box = boxconfig[:box_name]
            box.vm.host_name = boxname.to_s
            #box.vbguest.installer_hooks[:before_install] = ["yum install -y epel-release", "sleep 1"]
            #box.vbguest.installer_options = { allow_kernel_upgrade: false , enablerepo: true }
  
            
            box.vm.network "private_network", ip: boxconfig[:ip_addr]
            #box.vm.allow_fstab_modification = false
  
            box.vm.provider :virtualbox do |vb|
                    vb.customize ["modifyvm", :id, "--memory", "4096"]
                    vb.customize ["modifyvm", :id, "--cpus", "4"]
                    needsController = false
            boxconfig[:disks].each do |dname, dconf|
                unless File.exist?(dconf[:dfile])
                  vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Fixed', '--size', dconf[:size]]
                                  needsController =  true
                            end
  
            end
                    if needsController == true
                       vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
                       boxconfig[:disks].each do |dname, dconf|
                           vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
                       end
                    end
            end
  
          box.vm.provision "shell", path: "./preinstall_1.sh"
          box.vm.provision "shell", reboot: true   
          box.vm.provision "shell", path: "./preinstall_2.sh"
          box.vm.provision "shell", reboot: true      
          box.vm.provision "shell", path: "./step1.sh"
          
          box.vm.provision "shell", reboot: true
          #box.vm.provision :reload

          box.vm.provision "shell", path: "./step2.sh"
          box.vm.provision "shell", reboot: true
          box.vm.provision "shell", path: "./step3.sh"
          box.vm.provision "shell", reboot: true
          box.vm.provision "shell", path: "./step4.sh"
          box.vm.provision "shell", reboot: true
          box.vm.provision "shell", inline: <<-SHELL
            echo "Посмотрим диски в итоге"
            lsblk
            echo "Посмотрим, что в fstab"
            cat /etc/fstab
          SHELL

          end
  

        
    end
  end
  
