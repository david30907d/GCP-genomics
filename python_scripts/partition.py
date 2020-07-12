import sys

from biopartitioner.factory import PartitionerFactory

partitioner_caller = PartitionerFactory.create_partitioner("vcf")
dataset = sys.argv[1]
partition_num = int(sys.argv[2])
working_dir = sys.argv[3]
vcf_partioner = partitioner_caller(
    dataset=dataset, partition_num=partition_num, working_dir=working_dir
)
vcf_partioner.partition()
