FROM jupyter/pyspark-notebook:ubuntu-18.04
RUN wget -qO- https://get.nextflow.io | bash
COPY main.py main.py
COPY nextflow/helloworld.nf helloworld.nf
