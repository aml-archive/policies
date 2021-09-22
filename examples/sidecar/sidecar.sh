#!/bin/bash

# install OPA
kubectl apply -f sidecar.yaml
kubectl label namespace default opa-istio-injection=enabled
# kubectl label namespace default opa-istio-injection-

# install bookinfo app
kubectl apply -f istio/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f istio/samples/bookinfo/networking/bookinfo-gateway.yaml

# test
pm2 start "kubectl port-forward service/productpage 9080:9080 -n default"
# curl --user alice:password -i http://127.0.0.1:9080/productpage
# curl --user alice:password -i http://127.0.0.1:9080/api/v1/products
# pm2 kill
