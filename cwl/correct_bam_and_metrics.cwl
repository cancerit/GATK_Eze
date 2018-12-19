#!/usr/bin/env cwl-runner

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/
  s: http://schema.org/

$schemas:
- http://schema.org/docs/schema_org_rdfa.html
- http://dublincore.org/2012/06/14/dcterms.rdf
- http://xmlns.com/foaf/spec/20140114.rdf


class: CommandLineTool

id: "correct_bam_and_collect_metrics_for_gatk"

label: "Correct BMA and collect metrics for GATK pipeline"

cwlVersion: v1.0

doc: |
    ![build_status](https://quay.io/repository/wtsicgp/gatk_eze/status)
    See the [GATK_Eze](https://github.com/cancerit/GATK_Eze) website for more information.

dct:creator:
  "@id": "yaobo.xu@sanger.ac.uk"
  foaf:name: Yaobo Xu
  foaf:mbox: "yx2@sanger.ac.uk"

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/wtsicgp/gatk_eze:0.1.0"

hints:
  - class: ResourceRequirement
    coresMin: 1 # all processes are single threaded
    ramMin: 8000

inputs:

  in_bam:
    type: File
    doc: "input BAM to be converted to GATK ready format and to collect metrics from"
    inputBinding:
      position: 1
      shellQuote: true

  sanger_core_ref:
    type: File
    doc: "reference genome files in tar, as used in Sanger, GRCh37d5 can be downloaded here: http://ftp.sanger.ac.uk/pub/cancer/dockstore/human/core_ref_GRCh37d5.tar.gz"
    inputBinding:
      position: 2
      shellQuote: true

  mem:
    type: int
    doc: "number of GBs for max memory of Java processes to use"
    default: 12
    inputBinding:
      position: 3

outputs:

  reheadered_bam:
    type: File
    outputBinding:
      glob: $(inputs.in_bam.nameroot).mateinfo_fixed.bam
    secondaryFiles:
      .bai

  flag_stats_out:
    type: File
    outputBinding:
      glob: $(inputs.in_bam.nameroot).flag_stats.txt

  wgs_metrics_out:
    type: File
    outputBinding:
      glob: $(inputs.in_bam.nameroot).wgs_metrics.txt

  job_log:
    type: File
    outputBinding:
      glob: $(inputs.in_bam.nameroot).eze_gatk_part_1_correct.log

  verifybamID_out:
    type:
      type: array
      items: File
    outputBinding:
      glob: "$(inputs.in_bam.nameroot).verifybamID_out.*"
 
  multiple_metrics_out:
    type:
      type: array
      items: File
    outputBinding:
      glob: "$(inputs.in_bam.nameroot).multiple_metrics.*"

baseCommand: ["correct_bam_and_get_metrics.sh"]

s:codeRepository: https://github.com/cancerit/GATK_Eze
s:author:
  - class: s:Person
    s:email: mailto:cgphelp@sanger.ac.uk
    s:name: Yaobo Xu