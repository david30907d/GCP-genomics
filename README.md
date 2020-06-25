# GCP Genomics ![Spark Job CI](https://github.com/david30907d/GCP-genomics/workflows/Spark%20Job%20CI/badge.svg)

A repo which leverage GCP DataProc to analyze genomics data

## Prerequisites

1. Docker
2. Python3.X


## RUN

```bash
gcloud dataproc jobs submit pyspark \
    gs://dataproc-examples/pyspark/hello-world/hello-world.py \
    --cluster=cluster-name  \
    --region=region
```

docker pull jupyter/pyspark-notebook:ubuntu-18.04

/usr/local/spark/bin/spark-submit a.py