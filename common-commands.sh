  
# environment reset


kubectl delete memcacheds.cache.example.com example-memcached 
kubectl delete -f deploy/operator.yaml
operator-sdk build quay.io/sher_chowdhury/memcached-operator:v0.0.1
docker push quay.io/sher_chowdhury/memcached-operator:v0.0.1 



# Recreate operator and test it. 
kubectl apply -f deploy/operator.yaml
kubectl apply -f deploy/crds/cache.example.com_v1alpha1_memcached_cr.yaml