helm install stable/traefik --name lupinemoon-release --namespace kube-system --set dashboard.enabled=true,dashboard.domain=dashboard.localhost;
kubectl apply -f ./namespace.yml;
kubectl apply -f ./development/;
