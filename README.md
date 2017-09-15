# OpenShift Træfik

This repository contains a dockerized version of [træfik](https://www.traefik.io)
to be used on OpenShift 3.6 as a Ingress controller and Kubernetes backend.

## Run with Docker

    docker run -d -p 8080:8080 -p 8443:8443 -p 8081:8081 -v $PWD/etc/traefik.toml:/traefik.toml -v $PWD/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt -it philippallgeuer/openshift-traefik

| Port | Protocol     |
| :------------- | :------------- |
| 8080       | http traffic |
| 8443       | https traffic (default) |
| 8081       | traefik dashobard (UI) |

## Create on Openshift


### First step

Login and create a new namespace aka project. Kubernetes use namespaces Openshift in contrast use projects.
If you use a different project name ensure that all yaml files have this namespace.

    oc login https://<your-master-node>:8443
    oc new-project traefik-ingress

### Second step

Since Openshift 3.6 + Kubernetes 1.6 we use RBAC (RoleBasedAccessControl).
Create a ServiceAccount in this case ```traefik-ingress-serviceaccount``` with nessesery Role and ClusterRole.

    oc create -f openshift/traefik-rbac.yaml
    oc adm policy add-role-to-user traefik-ingress-role -z traefik-ingress-serviceaccount --role-namespace='traefik-ingress'
    oc adm policy add-cluster-role-to-user traefik-ingress-clusterrole  traefik-ingress-serviceaccount

### Third step

Create to nessesery volumes regarding traefik and let's encrypt config

    oc create -f openshift/acme_secret.yaml
    oc create -f openshift/traefik_configmap.yaml

### Fourth step

Deploy traefik ingress controler and service with ingress to expose the traefik dashboard

    oc create -f openshift/traefik-deployment.yaml
    oc create -f openshift/traefik-ui.yaml

## ToDo

- [x] write RoleBinding yaml file
- [x] write ClusterRoleBinding yaml file
- [x] impl. Let's Encrypt
- [ ] redirect http to https
- [ ] impl. prometheus for metric
- [x] pre_start hooks to exec ```chmod 600 acme.json```

## Issues

    Error from server (NotFound): error when creating "openshift/traefik-rbac.yaml": role.authorization.openshift.io "traefik-ingress-role" not found

    oc get role traefik-ingress-role

    NAME
    traefik-ingress-role
