package "kubernetes"

service "kube-proxy"
service "kubelet"

execute "edit KUBE_MASTER" do
  master_priv_ip = node['master01_private_ip']
  user "root"
  command <<"EOS"
sed -i.bak -e 's/KUBE_MASTER="--master=http:\\/\\/127.0.0.1:8080"/KUBE_MASTER="--master=http:\\/\\/#{master_priv_ip}:8080"/g' /etc/kubernetes/config
EOS
  not_if "grep 'master=http://#{master_priv_ip}:8080' /etc/kubernetes/config"
  notifies :restart, "service[kube-proxy]"
  notifies :restart, "service[kubelet]"
end

execute "edit KUBELET_ADDRESS" do
  user "root"
  command <<"EOS"
MY_PRIV_IP=`hostname -i` && sed -i.bak -e "s/KUBELET_ADDRESS=\\"--address=127.0.0.1\\"/KUBELET_ADDRESS=\\"--address=${MY_PRIV_IP}\\"/g" /etc/kubernetes/kubelet
EOS
  not_if 'MY_PRIV_IP=`hostname -i` && grep "address=${MY_PRIV_IP}" /etc/kubernetes/kubelet'
  notifies :restart, "service[kube-proxy]"
  notifies :restart, "service[kubelet]"
end

execute "edit KUBELET_HOSTNAME" do
  user "root"
  command <<"EOS"
sed -i.bak -e 's/KUBELET_HOSTNAME="--hostname-override=127.0.0.1"/KUBELET_HOSTNAME="--hostname-override="/g' /etc/kubernetes/kubelet
EOS
  not_if "grep 'KUBELET_HOSTNAME=\"--hostname-override=\"' /etc/kubernetes/kubelet"
  notifies :restart, "service[kube-proxy]"
  notifies :restart, "service[kubelet]"
end

execute "edit KUBELET_API_SERVER" do
  master_priv_ip = node['master01_private_ip']
  user "root"
  command <<"EOS"
sed -i.bak -e 's/KUBELET_API_SERVER="--api-servers=http:\\/\\/127.0.0.1:8080"/KUBELET_API_SERVER="--api-servers=http:\\/\\/#{master_priv_ip}:8080"/g' /etc/kubernetes/kubelet
EOS
  not_if "grep 'api-servers=http://#{master_priv_ip}:8080' /etc/kubernetes/kubelet"
  notifies :restart, "service[kube-proxy]"
  notifies :restart, "service[kubelet]"
end
