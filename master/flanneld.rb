package "flannel"

service "flanneld"

execute "edit ETCD_LISTEN_CLIENT_URLS" do
  user "root"
  command <<'EOS'
etcdctl mk /atomic.io/network/config '{"Network":"172.17.0.0/16"}'
EOS
  not_if "etcdctl get /atomic.io/network/config | grep '\"Network\":\"172.17.0.0/16\"'"
  notifies :restart, "service[flanneld]"
end
