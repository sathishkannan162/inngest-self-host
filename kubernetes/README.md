# Installing cert manager on your cluster
Make sure cert manager is installed in your cluster before applying the kubernetes file.

- Install cert manager with this command
`kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml`

# install ingress-nginx

- Run the following command to install ingress-nginx before apply the kubernetes file
`kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml`