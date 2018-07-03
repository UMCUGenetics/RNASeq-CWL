class: Workflow
cwlVersion: v1.0
id: base_recallibrator
label: base-recallibrator
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: reference
    type: File
    'sbg:x': 0
    'sbg:y': 0
  - id: inputBam_BaseRecalibrator
    type: File
    'sbg:x': 0
    'sbg:y': 213.84375
  - id: gatk_jar
    type: File
    'sbg:x': 0
    'sbg:y': 320.765625
  - id: covariate
    type:
      - 'null'
      - type: array
        items: string
        inputBinding:
          prefix: '--covariate'
    'sbg:exposed': true
  - id: java_arg
    type: string
    'sbg:exposed': true
  - id: known
    type:
      - 'null'
      - type: array
        items: File
        inputBinding:
          prefix: '--knownSites'
    'sbg:x': 0
    'sbg:y': 106.921875
  - id: outputfile_BaseRecalibrator
    type: string
    'sbg:exposed': true
  - id: covariate_1
    type:
      - 'null'
      - type: array
        items: string
        inputBinding:
          prefix: '--covariate'
    'sbg:exposed': true
  - id: java_arg_1
    type: string
    'sbg:exposed': true
  - id: outputfile_BaseRecalibrator_1
    type: string
    'sbg:exposed': true
  - id: java_arg_2
    type: string
    'sbg:exposed': true
  - id: plots
    type: string?
    'sbg:exposed': true
  - id: csv
    type: string?
    'sbg:exposed': true
  - id: java_arg_3
    type: string
    'sbg:exposed': true
  - id: outputfile_printReads
    type: string?
    'sbg:exposed': true
outputs:
  - id: output_pdf
    outputSource:
      - _analyze_covariats/output_pdf
    type: File?
    'sbg:x': 1047.261474609375
    'sbg:y': 213.84375
  - id: output_csv
    outputSource:
      - _analyze_covariats/output_csv
    type: File?
    'sbg:x': 1047.261474609375
    'sbg:y': 320.765625
  - id: output_printReads
    outputSource:
      - _g_a_t_k__print_reads/output_printReads
    type: File
    'sbg:x': 1047.261474609375
    'sbg:y': 106.921875
  - id: flagstats
    outputSource:
      - sambamba_flagstat/flagstats
    type: stdout
    'sbg:x': 1198.9371337890625
    'sbg:y': -76.60557556152344
steps:
  - id: _base_recalibrator
    in:
      - id: covariate
        default:
          - QualityScoreCovariate
        source:
          - covariate
      - id: gatk_jar
        source: gatk_jar
      - id: inputBam_BaseRecalibrator
        source: inputBam_BaseRecalibrator
      - id: java_arg
        source: java_arg
      - id: known
        source:
          - known
      - id: outputfile_BaseRecalibrator
        source: outputfile_BaseRecalibrator
      - id: reference
        source: reference
    out:
      - id: output_baseRecalibrator
    run: ../CWL-CommandLineTools/GATK/3.6/BaseRecalibrator.cwl
    'sbg:x': 273.75
    'sbg:y': 213.84375
  - id: _base_recalibrator_1
    in:
      - id: covariate
        source:
          - covariate_1
      - id: gatk_jar
        source: gatk_jar
      - id: inputBam_BaseRecalibrator
        source: inputBam_BaseRecalibrator
      - id: java_arg
        source: java_arg_1
      - id: known
        source:
          - known
      - id: outputfile_BaseRecalibrator
        source: outputfile_BaseRecalibrator_1
      - id: reference
        source: reference
      - id: BQSR
        source: _base_recalibrator/output_baseRecalibrator
    out:
      - id: output_baseRecalibrator
    run: ../CWL-CommandLineTools/GATK/3.6/BaseRecalibrator.cwl
    'sbg:x': 273.75
    'sbg:y': 57.921875
  - id: _analyze_covariats
    in:
      - id: java_arg
        source: java_arg_2
      - id: gatk_path
        source: gatk_jar
      - id: Reference
        source: reference
      - id: before
        source: _base_recalibrator/output_baseRecalibrator
      - id: after
        source: _base_recalibrator_1/output_baseRecalibrator
      - id: plots
        source: plots
      - id: csv
        source: csv
    out:
      - id: output_pdf
      - id: output_csv
    run: ../CWL-CommandLineTools/GATK/3.6/AnalyzeCovariats.cwl
    label: GATK-AnalyzeCovariats
    'sbg:x': 697.0625
    'sbg:y': 213.84375
  - id: _g_a_t_k__print_reads
    in:
      - id: gatk_jar
        source: gatk_jar
      - id: inputBam_printReads
        source: inputBam_BaseRecalibrator
      - id: input_baseRecalibrator
        source: _base_recalibrator/output_baseRecalibrator
      - id: java_arg
        source: java_arg_3
      - id: outputfile_printReads
        source: outputfile_printReads
      - id: reference
        source: reference
    out:
      - id: output_printReads
    run: ../CWL-CommandLineTools/GATK/3.6/GATK-PrintReads.cwl
    'sbg:x': 697.0625
    'sbg:y': 64.921875
  - id: sambamba_flagstat
    in:
      - id: bam_in
        source: _g_a_t_k__print_reads/output_printReads
    out:
      - id: flagstats
    run: ../../CWL-CommandLineTools/Sambamba/0.6.6/sambamba-flagstat.cwl
    'sbg:x': 1042.3338623046875
    'sbg:y': -75.29862213134766
requirements: []
