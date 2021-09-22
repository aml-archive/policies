# Open Policy Agent

[Open Policy Agent](https://www.openpolicyagent.org/docs/latest/) (OPA) runs within Istio as an external authorization service. Istio can be configured to delegate complex authz requests to OPA.

See [this article](https://istio.io/latest/blog/2021/better-external-authz/) for more.

## Deployment options

### Standalone

OPA is deployed as a single standalone service to handle all authorisation requests within the mesh. This is the simplest to configure.

See `/examples/standalone` for example deployed to Istio running locally on Minikube.

### Sidecar

OPA is deployed as a sidecar container into every microservice pod. This is more complicated to set up but is recommended as it can be more performant.

See `/examples/sidecar` for an example of OPA deployed as a sidecar container within
a microservice pod.

## Serving bundles

Policy bundles are served using Github Pages (gh-pages branch).

Bundles are built using:

    opa build <dir>
