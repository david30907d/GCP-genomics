#!/usr/bin/env nextflow

params.str = 'Hello world!'

process splitDatasetIntoPartitions {
    """
    python /app/python_scripts/partition.py /app/fixtures/scaffold.vcf 8 /app
    """
}

vcf_partition = Channel.fromPath( "/app/*.vcf" )

process transformPartitions {
    input:
    val vcf from vcf_partition

    output:
    val x into receiver
    stdout result

    shell:
    """
    plink1.9 --vcf !{vcf} --recode oxford
    """
}
result.view { it.trim() }