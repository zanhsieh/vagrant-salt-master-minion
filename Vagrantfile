# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vbguest.auto_update = false
  config.vm.box = "centos6.6"
  config.vm.box_check_update = false
  
  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box

    # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
    # NFS for shared folders. This is also very useful for vagrant-libvirt if you
    # want bi-directional sync
    config.cache.synced_folder_opts = {
      type: :nfs,
      # The nolock option can be useful for an NFSv3 client that wants to avoid the
      # NLM sideband protocol. Without this option, apt-get might hang if it tries
      # to lock files needed for /var/cache/* operations. All of this can be avoided
      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
    # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
  end

  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "192.168.40.11"
    master.vm.provision :shell, path: "install-salt-master.sh"
  end

  config.vm.define "minion1" do |minion1|
    minion1.vm.hostname = "minion1"
    minion1.vm.network "private_network", ip: "192.168.40.12"
    minion1.vm.provision :shell, path: "install-salt-minion.sh"
  end

  config.vm.define "minion2" do |minion2|
    minion2.vm.hostname = "minion2"
    minion2.vm.network "private_network", ip: "192.168.40.13"
    minion2.vm.provision :shell, path: "install-salt-minion.sh"
  end

end