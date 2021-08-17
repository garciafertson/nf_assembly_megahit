process fastp{
  scratch true
  //memory '6GB'
  cpus '1'
  time '4h'
  module 'bioinfo-tools:fastp'
  input:
    tuple val(x), path(reads)
  output:
    tuple val(x), path("${x}.R{1,2}.trim.fq.gz"), emit: reads
  script:

    """
    fastp --in1 ${reads[0]} \\
          --in2 ${reads[1]} \\
          --out1 "${x}.R1.trim.fq.gz" \\
          --out2 "${x}.R2.trim.fq.gz" \\
          --thread 1
    """
}
