#!/usr/bin/env nextflow

params.vcf_base_dir = '/app'

process splitDatasetIntoPartitions {
    echo true

    shell:
    """
    python $WORKING_DIR/python_scripts/partition.py $WORKING_DIR/fixtures/scaffold.vcf 8 $WORKING_DIR
    """
}

vcf_partition = Channel.fromPath(params.vcf_base_dir + "/*.vcf")

process transformPartitions {
    echo true

    input:
    val vcf from vcf_partition

    shell:
    """
    plink1.9 --vcf !{vcf} --recode oxford --out !{vcf}
    """
}

gens = Channel.fromPath(params.vcf_base_dir + "/*.gen").toList().get().join(" ")
samples = Channel.fromPath(params.vcf_base_dir + "/*.sample").toList().get().join(" ")

process mergeGens {
    echo true

    shell:
    """
    gtool -M --g !{gens} --s !{samples} --og !{params.vcf_base_dir}/merged.gen --os !{params.vcf_base_dir}/merged.sample
    """
}