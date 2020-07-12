FROM jupyter/pyspark-notebook:ubuntu-18.04
USER root
ENV POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR='/var/cache/pypoetry'

# gcc make libbz2-dev zlib1g-dev libncurses5-dev libncursesw5-dev liblzma-dev are required by htslib, samtools and bcftools
WORKDIR /app
RUN apt-get update \
    && apt-get install -y --no-install-recommends plink1.9=1.90~b5.2-180109-1 gcc=4:7.4.0-1ubuntu2.3 make=4.1-9.1ubuntu1 libbz2-dev=1.0.6-8.1ubuntu0.2 zlib1g-dev=1:1.2.11.dfsg-0ubuntu2 libncurses5-dev=6.1-1ubuntu1.18.04 libncursesw5-dev=6.1-1ubuntu1.18.04 liblzma-dev=5.2.2-1.3 \
    # install nextflow and grant permission to jupyter user jovyan
    && wget -qO- https://get.nextflow.io | bash \
    && chown -R "$NB_USER" .nextflow \
    && chown "$NB_USER" nextflow \
    # clean up apt lists
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml pyproject.toml
COPY poetry.lock poetry.lock
RUN pip3 install --no-cache-dir poetry==1.0.5
RUN poetry install --no-interaction --no-ansi \
    # Cleaning poetry installation's cache for production:
    && rm -rf "$POETRY_CACHE_DIR" \
    && pip uninstall -yq poetry \
    && rm -rf /tmp/* /var/cache/apk/*

# Download HTSLIB, SAMTOOLS and BCFTOOLS
WORKDIR /usr/bin
RUN wget https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2 \
    && tar -vxjf htslib-1.9.tar.bz2 \
    && wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 \
    && tar -vxjf samtools-1.9.tar.bz2 \
    && wget https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2 \
    && tar -vxjf bcftools-1.9.tar.bz2

# Install HTSLIB
WORKDIR /usr/bin/htslib-1.9
RUN make

# Install SAMTOOLS
WORKDIR /usr/bin/samtools-1.9
RUN make

# Install BCFTools
WORKDIR /usr/bin/bcftools-1.9
RUN make

WORKDIR /app
USER $NB_USER
COPY python_scripts python_scripts
COPY nextflow_pipelines/helloworld.nf helloworld.nf
COPY fixtures fixtures