# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

BUILD_IMAGE = true          # build docker image from Dockerfile
PROVISION_DOCKER = true     # install docker daemon on virtual machine
REMOVE_CONTAINER = true     # kill and remove the solr-container so it can be restarted
RUN_CONTAINER = true     # run the solr-container

RAM_MEGABYTES=1024
NUM_CPUS=1

ALPHA_HOST = {
  ip: '192.168.50.10',
  solr_port: 8983,
  hostname: 'alpha'
}

VM_HOSTS=[]
VM_HOSTS.push ALPHA_HOST

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  ###################
  # Virtual Machines
  ###################
  VM_HOSTS.each do | host |
    setup_host config, host
  end

  provision config # run all provisioners

  config.vm.provider :virtualbox do |v, override|
    virtualbox_setup v, override
  end

  config.vm.provider :vmware_fusion do |v, override|
    vmware_setup v, override
  end
end

def provision config
  if PROVISION_DOCKER
    config.vm.provision "docker" do | docker |
      docker.pull_images "ubuntu"
    end
  end
  run_shell_scripts config
end


def run_shell_scripts config
  config.vm.provision "shell", path: "./vagrant_scripts/initial.sh"

  if REMOVE_CONTAINER
    remove_container config
  end

  if BUILD_IMAGE
    config.vm.provision "shell", path: "./vagrant_scripts/build_image.sh"
  end

  if RUN_CONTAINER
    run_container config
  end
end


def setup_host config, host
  hostname = host[:hostname]
  config.vm.define "#{hostname}" do |item|
    # item.vm.network :private_network, ip: host[:ip]
    if host[:hostname]  == 'alpha'
      item.vm.network :forwarded_port, guest: 8983, host: host[:solr_port]
    end
    item.vm.hostname = hostname
  end
end

###################
# Virtualbox Provider
###################
def virtualbox_setup v, override
  override.vm.box = "precise64_virtualbox"
  override.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Use VBoxManage to customize the VM. For example to change memory:
  v.customize ["modifyvm", :id, "--memory", RAM_MEGABYTES]
  v.customize ["modifyvm", :id, "--cpus", NUM_CPUS]
end

###################
# Vmware Fusion Provider
###################
def vmware_setup v, override
  # override box and box_url when using the "--provider vmware_fusion" flag
  override.vm.box = "precise64_fusion"
  override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
  v.gui = false
  v.vmx["memsize"] = RAM_MEGABYTES
  v.vmx["numvcpus"] = NUM_CPUS
end

def remove_container config
    config.vm.provision "shell", path: "./vagrant_scripts/remove_container.sh"
end

def run_container config
    config.vm.provision "shell", path: "./vagrant_scripts/run_container.sh"
end
