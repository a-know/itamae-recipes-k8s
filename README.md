# itamae-recipes-k8s
## About this repository
[CloudGarage の無償インスタンスを利用して kubernetes クラスタを構築してみる](http://blog.a-know.me/entry/2017/10/01/214621)(in japanese)

## Usage
### 0. Prepare
This repository use `itamae`.

```console
$ bundle install
```

And, edit `~/.ssh/config` on your PC to enable to access each instance easily.

### 1. Create working user

```console
$ cp base/user_template.json base/my.json
<edit my.json>
$ bundle exec itamae ssh -h master01 -j base/my.json -u root base/user.rb
$ bundle exec itamae ssh -h node01  -j base/my.json -u root base/user.rb
$ bundle exec itamae ssh -h node02  -j base/my.json -u root base/user.rb
```

### 2. Edit `/etc/hosts`
```console
$ bundle exec itamae ssh -h master01  -j base/my_hosts.json -u root base/hosts.rb
$ bundle exec itamae ssh -h node01  -j base/my_hosts.json -u root base/hosts.rb
$ bundle exec itamae ssh -h node02  -j base/my_hosts.json -u root base/hosts.rb
```

### 3. Setup for master-node
```console
$ bundle exec itamae ssh -h master01 -j master/config.json master/etcd.rb
$ bundle exec itamae ssh -h master01 master/flanneld.rb
<Create secret key for serviceaccount.key, and save at files/ .>
$ bundle exec itamae ssh -h master01 -j master/config.json master/kubernetes.rb
$ bundle exec itamae ssh -h master01 -j master/config.json master/kubectl_config.rb
```

To create secret key, do `$ openssl genrsa -out /path/to/serviceaccount.key 2048` .

### 4. Setup for container-running node

```console
$ bundle exec itamae ssh -h node01 -j node/node_config.json node/flanneld.rb
$ bundle exec itamae ssh -h node02 -j node/node_config.json node/flanneld.rb
$ bundle exec itamae ssh -h node01 -j node/node_config.json node/kubernetes.rb
$ bundle exec itamae ssh -h node02 -j node/node_config.json node/kubernetes.rb
```

### 5. Check

```console
$ kubectl get nodes
NAME      STATUS    AGE
node01    Ready     3m
node02    Ready     9s
```

That's all!
