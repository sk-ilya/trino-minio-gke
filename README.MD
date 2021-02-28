## Install MinIO
```
helm install --namespace minio gke-bucket -f minio-values.yaml minio/minio
```


## Install Trino
Configuration files are placed in _trino-config_ and _hive-metastore_ folders. 


Creating configmaps
```
kubectl create configmap metastore-cfg --namespace minio --dry-run --from-file=hive-metastore/metastore-site.xml --from-file=hive-metastore/core-site.xml -o yaml | kubectl apply -f -
kubectl create configmap trino-configs --namespace minio --from-file=trino-configs/
kubectl create configmap trino-cli-startup --namespace minio --from-file=trino-cli-scripts/
```
Maria DB setup
```
kubectl apply -f maria-pvc.yaml 

kubectl apply -f maria-deployment.yaml 
```

Hive schema initialization
```
kubectl apply -f hive-initschema.yaml 
```

Hive metastore
```
kubectl apply -f metastore.yaml 
```

Partition sync
```
kubectl create -f partitionsync-cronjob.yaml
```
Trino
```
kubectl apply -f trino.yaml
```

enter trino cli
```
kubectl exec --stdin --tty trino-cli -- /bin/bash
```

In trino cli pod:
```
trino --server trino:8080 --catalog hive --schema default 
create schema hive.a with (location = 's3a://trino/warehouse');
create table a.test (id int);
insert into a.test values (123);
select * from a.test;
```


