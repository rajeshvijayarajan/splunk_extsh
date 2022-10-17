Recipe to use flannel as the overlay network, to enable external search heads (i.e. not a part of the k8s cluster) to search data being indexed by the indexers in the k8s cluster

### Step to be performed on the Ezmeral Control Plane (once for each external host):
```
ERTS_PATH=/opt/bluedata/common-install/bd_mgmt/erts-*/bin
NODETOOL=$ERTS_PATH/../../bin/nodetool
NAME_ARG=`egrep '^-s?name' $ERTS_PATH/../../releases/1/vm.args`
RPCCMD="$ERTS_PATH/escript $NODETOOL $NAME_ARG rpcterms"
${RPCCMD} bd_mgmt_api_float_info allocate ''
```

Sample output:
```
{ok,{"172.18.0.4",<<"ens192">>,<<"172.18.0.1">>}}
```

### Step to be performed on the K8s Master (once for each external host)
Use the above generated floating IP to create a node object.
```
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Node
metadata:
  name: <FQDN-of-external-sh>
  labels:
    node-role.kubernetes.io/external-host: ""
spec:
  podCIDR: <IP generated above- for e.g. 172.18.0.4>/32>
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/external-host
  - effect: NoExecute
    key: node-role.kubernetes.io/external-host
  unschedulable: true
EOF
```

Sample output:
```
[root@ip-10-21-0-107 ext_flannel]# kubectl get nodes
NAME                                             STATUS                        ROLES                  AGE   VERSION
ip-10-21-0-107.ap-southeast-1.compute.internal   Ready                         control-plane,master   63d   v1.20.11
ip-10-21-0-122.ap-southeast-1.compute.internal   NotReady,SchedulingDisabled   external-sh            28d   v1.20.11
ip-10-21-0-222.ap-southeast-1.compute.internal   Ready                         worker                 63d   v1.20.11
ip-10-21-0-35.ap-southeast-1.compute.internal    Ready                         worker                 63d   v1.20.11
```

### Steps to be performed on each external host (search head):

#### Install and configure flannel
```
./get_flannel.sh 
./configure_flannel.sh
./configure_firewall.sh  
./configure_flannel_svc.sh 
```

#### Install and configure kube-proxy
```
./install_kube-proxy.sh
./configure_kube-proxy.sh
```

#### Validate the connectivity using:
```
# Lookup pod and service FQDNs
nslookup <pod-ip>.<namespace>.pod.cluster.local
nslookup <svc-name>.<namespace>.svc.cluster.local
# Ping a pod IP
ping -c 1 <pod-ip>
```	
