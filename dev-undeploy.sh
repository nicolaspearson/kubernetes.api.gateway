helm del --purge lupinemoon-release;
kubectl delete -f ./namespace.yml;
kubectl delete -f ./development;
