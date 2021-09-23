#!/bin/bash

install() {
  # add external authz to Istio mesh config
  mesh=$(kubectl get configmap/istio -n istio-system -o 'go-template={{index .data "mesh" }}')
  mesh=$(echo "$mesh" | sed '/extensionProviders:/,$ d')
  mesh=$(echo "$mesh" | sed '2,$ s/^/      /')
  patch=$(cat <<EOF
  data:
    mesh: |-
      $mesh
      extensionProviders:
      - name: opa-authz
        envoyExtAuthzGrpc:
          service: opa.default.svc.cluster.local
          port: 9191
EOF
  )
  kubectl patch configmap/istio -n istio-system --patch "$patch"
  kubectl rollout restart deployment/istiod -n istio-system

  # add OPA authz
  kubectl apply -f standalone.yaml

  # install bookinfo app
  kubectl apply -f istio/samples/bookinfo/platform/kube/bookinfo.yaml
  kubectl apply -f istio/samples/bookinfo/networking/bookinfo-gateway.yaml
}

# test
test(){
  # minikube tunnel --cleanup
  # minikube service --url productpage
  PORT=$(kubectl get service istio-ingressgateway -n istio-system --output='jsonpath={.spec.ports[?(@.name=="http2")].nodePort}')
  ADDR=$(minikube ip)
  curl --user alice:password -i http://$ADDR:$PORT/productpage
  curl --user alice:password -i http://$ADDR:$PORT/api/v1/products
}

# clean up
uninstall() {
  mesh=$(kubectl get configmap/istio -n istio-system -o 'go-template={{index .data "mesh" }}')
  echo "$mesh"
  mesh=$(echo "$mesh" | sed '/extensionProviders:/,$ d')
  mesh=$(echo "$mesh" | sed '2,$ s/^/      /')
  patch=$(cat <<EOF
  data:
    mesh: |-
      $mesh
EOF
  )
  kubectl patch configmap/istio -n istio-system --patch "$patch"
  kubectl rollout restart deployment/istiod -n istio-system
  kubectl delete -f standalone.yaml
  kubectl delete -f istio/samples/bookinfo/platform/kube/bookinfo.yaml
  kubectl delete -f istio/samples/bookinfo/networking/bookinfo-gateway.yaml
}

"$@"
