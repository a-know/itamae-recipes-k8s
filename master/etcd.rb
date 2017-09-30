package "etcd"

service "etcd"

execute "edit ETCD_LISTEN_CLIENT_URLS" do
  master_priv_ip = node['master01_private_ip']
  user "root"
  command <<"EOS"
sed -i.bak -e 's/ETCD_LISTEN_CLIENT_URLS="http:\\/\\/localhost:2379"/ETCD_LISTEN_CLIENT_URLS="http:\\/\\/#{master_priv_ip}:2379,http:\\/\\/localhost:2379"/g' /etc/etcd/etcd.conf
EOS
  not_if "grep '#{master_priv_ip}:2379' /etc/etcd/etcd.conf"
  notifies :restart, "service[etcd]"
end
