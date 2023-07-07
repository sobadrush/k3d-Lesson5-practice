k3d cluster create \
-p "18093:8093@loadbalancer" \
-p "17001:7001@loadbalancer" \
-p "18787:8787@loadbalancer" \
--config k3d-default.yaml \
--registry-use k3d-app-registry:30725 \
--volume /tmp/k3dvolGG:/tmp/k3dvol

# PV
kubectl apply -f k3d-pv.yaml

# ns
kubectl create ns k3d-tst

# PVC
k apply -f pvc-k3d-tst.yaml -n k3d-tst

# deploy
kubectl apply -f deploy.yaml -n k3d-tst

# svc
k apply -f service.yaml -n k3d-tst

# ingress
k apply -f ingress.yaml -n k3d-tst

# logs
k ${pod-Name} -f

# enter into pod
k exec -it pod/masa-base-webapp-7688fc7ffd-67qhg -- /bin/bash

# test
curl -X GET http://localhost:18093/masaChatBot/testController/testGet

# delete k3d cluster
k3d cluster delete k3s-default

# 建立 sibling deploy 進行 debug
kubectl create deployment nginx --image=k3d-app-registry:30725/mynginx:v0.1