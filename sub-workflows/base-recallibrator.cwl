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
    'sbg:y': 53.3671875
  - id: inputBam_BaseRecalibrator
    type: File
    'sbg:x': 0
    'sbg:y': 266.6796875
  - id: gatk_jar
    type: File
    'sbg:x': 273.75
    'sbg:y': 4.328125
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
    'sbg:y': 160.0234375
  - id: outputfile_BaseRecalibrator
    type: string
    'sbg:exposed': true
  - id: output
    type: string
    'sbg:exposed': true
  - id: java_args
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
outputs:
  - id: output_pdf
    outputSource:
      - _analyze_covariats/output_pdf
    type: File?
    'sbg:x': 934.5650024414062
    'sbg:y': 213.390625
  - id: output_csv
    outputSource:
      - _analyze_covariats/output_csv
    type: File?
    'sbg:x': 934.5650024414062
    'sbg:y': 320.046875
  - id: bam_out
    outputSource:
      - gatk_reassignonemappingqualityfilter/bam_out
    type: File
    'sbg:x': 968.7677001953125
    'sbg:y': 71.4393081665039
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
    'sbg:y': 294.6796875
  - id: gatk_reassignonemappingqualityfilter
    in:
      - id: Reference
        source: reference
      - id: INPUT
        source: inputBam_BaseRecalibrator
      - id: output
        source: output
      - id: java_args
        source: java_args
      - id: gatk_jar
        source: gatk_jar
      - id: BQSR
        source: _base_recalibrator/output_baseRecalibrator
    out:
      - id: bam_out
    run: ../CWL-CommandLineTools/GATK/3.6/PrintReads.cwl
    label: GATK-PrintReads
    'sbg:x': 697.0625
    'sbg:y': 64.65625
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
    'sbg:y': 139.0234375
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
    'sbg:y': 213.3515625
requirements: []
