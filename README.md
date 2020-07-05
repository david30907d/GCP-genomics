# GCP Genomics ![Spark Job CI](https://github.com/david30907d/GCP-genomics/workflows/Spark%20Job%20CI/badge.svg)

A repo which leverage GCP DataProc to analyze genomics data

## Prerequisites

1. Docker
2. Python3.X


## RUN

### Local
```bash
gcloud dataproc jobs submit pyspark \
    gs://dataproc-examples/pyspark/hello-world/hello-world.py \
    --cluster=cluster-name  \
    --region=region
```

docker pull jupyter/pyspark-notebook:ubuntu-18.04

/usr/local/spark/bin/spark-submit a.py

### GCP

1. `gcloud dataproc clusters create test2-cluster --region=asia-east1 --master-machine-type=custom-1-3584 --worker-machine-type=custom-1-3584 (--num-secondary-workers=2)`
2. `gcloud dataproc jobs submit spark --cluster test2-cluster \
  --region=asia-east1 \
  --class org.apache.spark.examples.SparkPi \
  --jars file:///usr/lib/spark/examples/jars/spark-examples.jar -- 1000`
3. `gcloud dataproc clusters delete test2-cluster --region=asia-east1`