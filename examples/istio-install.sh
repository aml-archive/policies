#!/bin/bash

# curl -L https://istio.io/downloadIstio | sh -

minikube start
istio/bin/istioctl install --set profile=demo -y
# istio/bin/istioctl install --set profile=default -y./
kubectl label namespace default istio-injection=enabled
istio/bin/istioctl analyze
