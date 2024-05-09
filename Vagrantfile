Vagrant.configure(2) do |config|

    N = 2
    (1..N).each do |i|
      config.vm.define "mysql#{i}" do |node|
        node.vm.box = "centos/7"
        node.vm.hostname = "mysql#{i}"
        node.vm.network "private_network", ip:"10.0.26.10#{i}"
        node.vm.provider "virtualbox" do |vb|
          vb.memory = "2048"
          vb.name = "mysql#{i}"
          vb.cpus = 1
        end
      if i == N
      node.vm.provision "ansible" do |ansible|
        #ansible.verbose = "vvv"
        ansible.limit = "all"
        #ansible.config_file = "ansible/ansible.cfg"
        ansible.playbook = "ansible/provision.yml"
        ansible.host_key_checking = "false"
        ansible.compatibility_mode = "2.0"
        ansible.become = "true"
        #ansible.inventory_path = "ansible/hosts"
        ansible.host_vars = {
        "mysql1" => {"srv_id" => "1"},
        "mysql2" => {"srv_id" => "2"},
      }
      end
    end
  end
 end
end