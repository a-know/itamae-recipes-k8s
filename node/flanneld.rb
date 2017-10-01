package "flannel"
package "docker"

service "flanneld"
service "docker"

execute "edit FLANNEL_ETCD_ENDPOINTS" do
  master_priv_ip = node['master01_private_ip']
  user "root"
  command <<"EOS"
sed -i.bak -e 's/FLANNEL_ETCD_ENDPOINTS="http:\\/\\/127.0.0.1:2379"/FLANNEL_ETCD_ENDPOINTS="http:\\/\\/#{master_priv_ip}:2379"/g' /etc/sysconfig/flanneld
EOS
  not_if "grep '#{master_priv_ip}:2379' /etc/sysconfig/flanneld"
  notifies :restart, "service[flanneld]", :immediately
  notifies :restart, "service[docker]"
end
