execute "add master01 to /etc/hosts" do
  user "root"
  command "echo '#{node['master01_private_ip']} master01' >> /etc/hosts"
  not_if "grep master01 /etc/hosts"
end

execute "add node01 to /etc/hosts" do
  user "root"
  command "echo '#{node['node01_private_ip']} node01' >> /etc/hosts"
  not_if "grep node01 /etc/hosts"
end

execute "add node02 to /etc/hosts" do
  user "root"
  command "echo '#{node['node02_private_ip']} node02' >> /etc/hosts"
  not_if "grep node02 /etc/hosts"
end
