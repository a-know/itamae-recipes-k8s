package "kubernetes"

service "kube-apiserver"
service "kube-controller-manager"
service "kube-scheduler"
service "kube-proxy"

remote_file "/etc/kubernetes/serviceaccount.key" do
  owner "root"
  group "root"
  mode '0644'
  source "../files/serviceaccount.key"
  notifies :restart, "service[kube-apiserver]"
  notifies :restart, "service[kube-controller-manager]"
  notifies :restart, "service[kube-scheduler]"
  notifies :restart, "service[kube-proxy]"
end

execute "edit KUBE_API_ADDRESS" do
  master_priv_ip = node['master01_private_ip']
  user "root"
  command <<"EOS"
sed -i.bak -e 's/KUBE_API_ADDRESS="--insecure-bind-address=127.0.0.1"/KUBE_API_ADDRESS="--insecure-bind-address=#{master_priv_ip}"/g' /etc/kubernetes/apiserver
EOS
  not_if "grep 'insecure-bind-address=#{master_priv_ip}' /etc/kubernetes/apiserver"
  notifies :restart, "service[kube-apiserver]"
  notifies :restart, "service[kube-controller-manager]"
  notifies :restart, "service[kube-scheduler]"
  notifies :restart, "service[kube-proxy]"
end

execute "edit KUBE_API_ARGS" do
  user "root"
  command <<"EOS"
sed -i.bak -e 's/KUBE_API_ARGS=""/KUBE_API_ARGS="--service_account_key_file=\\/etc\\/kubernetes\\/serviceaccount.key"/g' /etc/kubernetes/apiserver
EOS
  not_if "grep 'service_account_key_file=/etc/kubernetes/serviceaccount.key' /etc/kubernetes/apiserver"
  notifies :restart, "service[kube-apiserver]"
  notifies :restart, "service[kube-controller-manager]"
  notifies :restart, "service[kube-scheduler]"
  notifies :restart, "service[kube-proxy]"
end

execute "edit KUBE_CONTROLLER_MANAGER_ARGS" do
  user "root"
  command <<"EOS"
sed -i.bak -e 's/KUBE_CONTROLLER_MANAGER_ARGS=""/KUBE_CONTROLLER_MANAGER_ARGS="--service_account_private_key_file=\\/etc\\/kubernetes\\/serviceaccount.key"/g' /etc/kubernetes/controller-manager
EOS
  not_if "grep 'service_account_private_key_file=/etc/kubernetes/serviceaccount.key' /etc/kubernetes/controller-manager"
  notifies :restart, "service[kube-apiserver]"
  notifies :restart, "service[kube-controller-manager]"
  notifies :restart, "service[kube-scheduler]"
  notifies :restart, "service[kube-proxy]"
end

execute "edit KUBE_MASTER" do
  master_priv_ip = node['master01_private_ip']
  user "root"
  command <<"EOS"
sed -i.bak -e 's/KUBE_MASTER="--master=http:\\/\\/127.0.0.1:8080"/KUBE_MASTER="--master=http:\\/\\/#{master_priv_ip}:8080"/g' /etc/kubernetes/config
EOS
  not_if "grep '--master=http://#{master_priv_ip}:8080' /etc/kubernetes/config"
  notifies :restart, "service[kube-apiserver]"
  notifies :restart, "service[kube-controller-manager]"
  notifies :restart, "service[kube-scheduler]"
  notifies :restart, "service[kube-proxy]"
end
