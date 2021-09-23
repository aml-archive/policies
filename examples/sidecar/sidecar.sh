#!/bin/bash

install() {
  kubectl apply -f sidecar.yaml
  kubectl label namespace default opa-istio-injection=enabled --overwrite
  kubectl wait --for=condition=Available deployment/admission-controller -n opa-istio
  kubectl apply -f istio/samples/bookinfo/platform/kube/bookinfo.yaml
  kubectl apply -f istio/samples/bookinfo/networking/bookinfo-gateway.yaml
}

test() {
  # minikube service --url istio-ingressgateway -n istio-system

  # minikube tunnel --cleanup
  PORT=80
  ADDR=127.0.0.1
  # PORT=$(kubectl get service istio-ingressgateway -n istio-system --output='jsonpath={.spec.ports[?(@.name=="http2")].nodePort}')
  # ADDR=$(minikube ip)

  curl --user alice:password -i http://$ADDR:$PORT/productpage
  curl --user alice:password -i http://$ADDR:$PORT/api/v1/products

  # debugging
  # kubectl logs "$(kubectl get pod -l app=ext-authz -n foo -o jsonpath={.items..metadata.name})" -n foo -c ext-authz
}

uninstall() {
  kubectl patch configmap/istio -n istio-system --patch "$patch"
  kubectl rollout restart deployment/istiod -n istio-system
  kubectl delete -f sidecar.yaml
  kubectl label namespace default opa-istio-injection-
  kubectl delete -f istio/samples/bookinfo/platform/kube/bookinfo.yaml
  kubectl delete -f istio/samples/bookinfo/networking/bookinfo-gateway.yaml
}

"$@"