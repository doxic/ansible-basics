# -*- mode: ruby -*-
# vi: set ft=ruby :

# based on github.com/lowescott

# Specify Vagrant version, Vagrant API version, and desired clone location
Vagrant.require_version '>= 1.6.0'
VAGRANTFILE_API_VERSION = '2'

# Require 'yaml' module
require 'yaml'

# Read YAML file with VM details (box, CPU, and RAM)
machines = YAML.load_file(File.join(File.dirname(__FILE__), 'machines.yml'))

# Create and configure the VMs
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Always use Vagrant's default insecure key
  config.ssh.insert_key = true

  # Iterate through entries in YAML file to create VMs
  machines.each do |machine|
    config.vm.define machine['name'] do |srv|

      # Don't check for box updates
      srv.vm.box_check_update = false
      srv.vm.hostname = machine['name']
      srv.vm.box = machine['box']

      # Configure default synced folder (enable by default)
      if machine['sync_disabled'] == true
        srv.vm.synced_folder '.', '/vagrant', disabled: true
      else
        srv.vm.synced_folder '.', '/vagrant', disabled: machine['sync_disabled'], type: "virtualbox", mount_options: ["fmode=600"]
      end #if machine['sync_disabled']

      # Assign additional private network
      if machine['ip_addr'] != nil
        if machine['int_net'] != nil
          srv.vm.network :private_network, ip: machine['ip_addr'],
          virtualbox__intnet: "DHCPScope"
        else
          machine['ip_addr'].each do |ip_addr|
            srv.vm.network 'private_network', ip: ip_addr
          end # machine['ip_addr'].each
        end #if machine['int_net']
      end # if machine['ip_addr']

      # Configure CPU & RAM per settings in machines.yml (virtualbox)
      srv.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--name", machine['name']]
        vb.customize ["modifyvm", :id, "--memory", machine['memory']]
        vb.customize ["modifyvm", :id, "--cpus", machine['cpu']]
        vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
        if machine['gui'] == true
          vb.customize ["modifyvm", :id, "--vram", 128]
          vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
          vb.customize ["modifyvm", :id, "--accelerate2dvideo", "on"]
        end #if machine['gui']
        # use the host's DNS API to query the information
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.linked_clone = true if Vagrant::VERSION =~ /^1.8/
		# Additional nicpromisc command
		if machine['nicpromisc'] != nil
		  machine['nicpromisc'].each do |command|
		    vb.customize ["modifyvm", :id, command, "allow-all"]
		  end # machine['nicpromisc'].each
		end # machine['nicpromisc']
      end

      # Ansible Parallel Execution from a Controller Guest
      # Provision the VM with Ansible if enabled in machines.yml
      if machine['ansible'] != nil
        srv.vm.provision :ansible_local do |ansible|
          ansible.playbook          = machine['ansible']
          ansible.verbose           = true
          ansible.install           = true
          ansible.limit             = "all" # or only "nodes" group, etc.
          ansible.inventory_path    = "inventory"
          ansible.provisioning_path = "/vagrant/provisioning"
        end #machine.vm.ansible
      end # if machine['provision']

      # Provision the VM with Shell if enabled in machines.yml
      if machine['shell'] != nil
        srv.vm.provision "shell", path: machine['shell']
      end # if machine['provision']
    end # config.vm.define
  end # machines.each
end # Vagrant.configure
