
process enadataget{
  //set directives to control

  scratch true
  memory '6GB'
  cpus '1'
  time '4h'
  module 'conda'
  maxForks=5
  maxeRetries 3

  input:
    val x

  output:
    tuple val(x), path ("${x}/*_{1,2}.fastq.gz") , emit: reads

  script:

  """
  python /home/jfgarcia/local_programs/enaBrowserTools-0.0.3/python3/enaDataGet.py \\
  -f fastq \\
  -d . \\
  ${x}
  """
}
