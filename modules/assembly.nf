process megahit_assembly{

  module "bioinfo-tools: megahit"
  publishDir "test_nf_assemblies",
    mode: 'copy',
    overwrite: false
  cpus 10
  time "10h"

  input:
    tuple val(x) ,path(reads)

  output:
    tuple val(x), path("megahit_out/${x}.contigs.fa") , emit:assembly

  script:
  //def mem_mh = task.memory.toBytes()
    """
    megahit \\
    -1 ${reads[0]} \\
    -2 ${reads[1]} \\
    -t ${task.cpus} \\
    -o megahit_out \\
    --out-prefix ${x} \\
    --min-contig-len 2000
    """
}
