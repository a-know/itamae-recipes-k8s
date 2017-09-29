groups = {}

user node['uid'] do
  gid node['gid'] unless node['uid'] == node['gid']
  password node['password']
  home node['home']
  shell node['shell']
end

(node['groups'] || []).each do |name|
  groups[name] ||= []
  groups[name] << node['uid']
end

directory node['home'] do
  owner node['uid']
  group node['gid']
  mode '0755'
  action :create
end

[ "#{node['home']}/.ssh" ].each do |dir|
  directory dir do
    owner node['uid']
    group node['gid']
    mode '0755'
    action :create
  end
end

file "#{node['home']}/.ssh/authorized_keys" do
  content node['authorized_keys'].join("\n")
  owner node['uid']
  group node['gid']
  mode '0600'
  action :create
end

groups.each do |name, members|
  group name do
    members members
    action :manage
  end
end

execute "add to sudoers" do
  user "root"
  command "echo '#{node['uid']} ALL=NOPASSWD: ALL' >> /etc/sudoers"
  not_if "grep #{node['uid']} /etc/sudoers"
end
