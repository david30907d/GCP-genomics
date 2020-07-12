#!/usr/bin/env nextflow

process splitDatasetIntoPartitions {
    echo true

    shell:
    """
    python $WORKING_DIR/python_scripts/partition.py $WORKING_DIR/fixtures/scaffold.vcf 8 $WORKING_DIR
    """
}

vcf_partition = Channel.fromPath("/app/*.vcf")

process transformPartitions {
    echo true
    input:
    val vcf from vcf_partition

    output:
    // val x into receiver

    shell:
    """
    plink1.9 --vcf !{vcf} --recode oxford
    """
}