```
operator-sdk new wordpress-operator --repo=github.com/codingbee/my-wordpress-operator
cd wordpress-operator
operator-sdk add api --api-version=cache.codingbee.net/v1alpha1 --kind=Wordpress  # kind needs to start with uppercase
kubectl create -f deploy/crds/cache.codingbee.net_wordpresses_crd.yaml
```

## this results in:
```
$ kubectl get customresourcedefinitions | grep -i wordpress
wordpresses.cache.codingbee.net                            2020-02-09T12:52:08Z

$ kubectl get customresourcedefinitions wordpresses.cache.codingbee.net -o yaml
```


```
kubectl create -f deploy/crds/cache.codingbee.net_v1alpha1_wordpress_cr.yaml
```

This ends up creating a custom resource:


```
$ kubectl get wordpress
NAME                AGE
example-wordpress   4m36s
```

This ends up creating a cr, but without any child elements, e.g. deployments, services, configmaps,...etc. Essentially so far we have only created an api endpoint using teh crd, and used our example cr yaml file to tell the api to add a this cr's info to the etcd key-value store. If you want to delete this cr along with it's crd, then you can just run:

```
kubectl delete customresourcedefinitions wordpresses.cache.codingbee.net
```

This ends up wiping out the crd's etc table along with all the cr entries it has contained within it.  




```
operator-sdk add controller --api-version=cache.codingbee.net/v1alpha1 --kind=Wordpress
```

Update controller go file, 


then build an image of it. 

```
operator-sdk build quay.io/sher_chowdhury/wordpress-operator:v0.0.1
docker push quay.io/sher_chowdhury/wordpress-operator:v0.0.1
```

Update deployment yaml file that will deploy this new image:

```
sed -i "" 's|REPLACE_IMAGE|quay.io/sher_chowdhury/wordpress-operator:v0.0.1|g' deploy/operator.yaml

```

Then deploy operator along with it's dependencies:

```
kubectl create -f deploy/service_account.yaml
kubectl create -f deploy/role.yaml
kubectl create -f deploy/role_binding.yaml
kubectl create -f deploy/operator.yaml
```

This will end up creating the operator pod, which in turn will create the default pod as specified in the controller.go file. by default this is a busybox pod. 


You can see a copy of this file at top level - wordpress_controller-sher-sample.go
