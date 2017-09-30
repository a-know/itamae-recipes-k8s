directory "/home/#{node['working_user']}/.kube" do
  mode "775"
  user node['working_user']
end

template "/home/#{node['working_user']}/.kube/config" do
  mode "600"
  user node['working_user']
  source "../templates/.kubeconfig.erb"
  variables(master_priv_ip: node['master01_private_ip'], kubectl_admin_password: node['kubectl_admin_password'])
end
