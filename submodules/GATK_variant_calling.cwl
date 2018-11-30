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
    htc_input_bam:
        type: File[]
        secondaryFiles: ^.bai
    htc_stand_call_conf: int?
    htc_stand_emit_conf: int?
    htc_out: string
    clusterSize: int?
    clusterWindowSize: int?
    htc_dont_use_softclipped_bases: boolean?
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
    snpeff_jar: File            
    snpeff_config: File
    snpeff_database: string
    snpeff_hgvs:  boolean
    snpeff_lof: boolean
    snpeff_no-downstream: boolean
    snpeff_no-upstream: boolean
    snpeff_no-intergenic: boolean

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
    snpeff_annotated_vcf:
        type: File
        outputSource: snpeff_annotate_variants/output_snpeff

steps:
    gatk_haplotype_caller:
        run: ../CWL-CommandLineTools/GATK/3.4-46/HaplotypeCaller.cwl
        in:
            gatk_jar: gatk_jar
            reference_sequence: genome
            input: htc_input_bam
            dont_use_softclipped_bases: htc_dont_use_softclipped_bases
            out: htc_out
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
    snpeff_annotate_variants:
        run:  ../CWL-CommandLineTools/SnpEf/4.1h/SnpEff.cwl
        in:
            snpeff_jar: snpeff_jar
            config: snpeff_config
            database: snpeff_database
            vcf: gatk_combine_variants/output_vcf
            hgvs: snpeff_hgvs
            lof: snpeff_lof
            no-downstream: snpeff_no-downstream
            no-upstream: snpeff_no-upstream
            no-intergenic: snpeff_no-intergenic
        out: [output_snpeff]