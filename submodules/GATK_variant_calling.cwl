class: Workflow
cwlVersion: v1.0
label: GATK_variant_Calling

requirements:
    - class: ScatterFeatureRequirement
    - class: StepInputExpressionRequirement
    - class: InlineJavascriptRequirement
inputs:
    gatk_jar:
        type: File
        inputBinding:
          position: 2
          prefix: '-jar'
    genome:
        type: File
        secondaryFiles:
            - .amb
            - .ann
            - .bwt
            - .pac
            - .sa
            - .fai
            - ^.dict 
        inputBinding:
          prefix: --reference_sequence
          position: 5
    htc_input_bam:
        type: File[]
        secondaryFiles: ^.bai
        inputBinding:
          prefix: --input_file  
          position: 5 
    htc_stand_call_conf:
        type: int?
        inputBinding:
          prefix: --stand_call_conf
          position: 5
    htc_stand_emit_conf:
        type: int?
        inputBinding:
          prefix: --stand_emit_conf
          position: 5
    htc_out:
        type: string
        inputBinding:
          prefix: --out
          position: 5
    clusterSize:
        type: int?
        inputBinding:
          prefix: --clusterSize
          position: 5
    clusterWindowSize:
        type: int?
        inputBinding:  
          prefix: --clusterWindowSize
          position: 5
    htc_dont_use_softclipped_bases:
        type: boolean?
        inputBinding:
          prefix: --dontUseSoftClippedBases
          position: 5
    select_variants_types:
        type:
           type: array
           items:
             type: array
             items: string
    select_variants_out: string[]

    variant_filtration_names:
        type:
           type: array
           items:
             type: array
             items: string
    variant_filtration_exp:
        type:
           type: array
           items:
             type: array
             items: string
    variant_filtration_out: string[]
    combine_variants_out: string
    assume_identical_samples: boolean

outputs:

    haplotype_caller_vcf:
        type: File
        outputSource: gatk_haplotype_caller/output_vcf
    select_variants_vcf:
        type: File[]
        outputSource: gatk_select_variants/output_vcf
    variant_filtration_vcf:
        type: File[]
        outputSource: gatk_variant_filtration/output_vcf
    combine_variants_vcf:
        type: File
        outputSource: gatk_combine_variants/output_vcf

steps:
    gatk_haplotype_caller:
        run: ../CWL-CommandLineTools/GATK/3.4-46/HaplotypeCaller.cwl
        in:
            gatk_jar: gatk_jar
            reference_sequence: genome
            input: htc_input_bam
            dont_use_softclipped_bases: htc_dont_use_softclipped_bases
            output: htc_out
        out: [output_vcf]
   
    gatk_select_variants:
        run: ../CWL-CommandLineTools/GATK/3.4-46/SelectVariants.cwl
        in:
            gatk_jar: gatk_jar
            reference_sequence: genome
            variant: gatk_haplotype_caller/output_vcf
            out: select_variants_out
            selectType: select_variants_types
        scatter: [selectType, out]
        scatterMethod: dotproduct
        out: [output_vcf]
    
    gatk_variant_filtration:
        run: ../CWL-CommandLineTools/GATK/3.4-46/VariantFiltration.cwl
        in:
            gatk_jar: gatk_jar
            reference_sequence: genome
            variant: gatk_select_variants/output_vcf
            out: variant_filtration_out
            filterName: variant_filtration_names
            filterExpression: variant_filtration_exp
        scatter: [variant, out, filterName, filterExpression]
        scatterMethod: dotproduct
        out: [output_vcf]
    gatk_combine_variants:
        run: ../CWL-CommandLineTools/GATK/3.4-46/CombineVariants.cwl
        in:
            gatk_jar: gatk_jar
            reference_sequence: genome
            variant: gatk_variant_filtration/output_vcf
            out: combine_variants_out
            assumeIdenticalSamples: assume_identical_samples
        out: [output_vcf]