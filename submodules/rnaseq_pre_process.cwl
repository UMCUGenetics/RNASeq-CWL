class: Workflow
cwlVersion: v1.0
label: RNAseq pre-processing workflow. 

requirements:
    - class: StepInputExpressionRequirement
    - class: InlineJavascriptRequirement

inputs:
    picard_jar: File
    picard_input_bam: File
    picard_rg_ReadGroupID: string
    picard_rg_ReadGroupLibrary: string
    picard_rg_ReadGroupPlatform: string
    picard_rg_ReadGroupPlatformUnit: string
    picard_rg_ReadGroupSampleName: string
    gatk_jar: File
    reference_sequence:
        type: File
        secondaryFiles:
            - .amb
            - .ann
            - .bwt
            - .pac
            - .sa
            - .fai
            - ^.dict 
    sncigar_n_cigar: string
    sncigar_rf: string?
    sncigar_RMQF: int?
    sncigar_RMQT: int?
    known_sites: File[]?
outputs:
    read_group_bam:
        type: File
        outputSource: picard_read_groups/out_bam
    rg_flagstat:
        type: File
        outputSource: sambamba_rg_flagstat/output_flagstat 
    mdup_bam:
        type: File
        outputSource: picard_mdup/markDups_output
    mdub_flagstat:
        type: File
        outputSource: sambamba_mdub_flagstat/output_flagstat 
    splitNCigar_bam:
        type: File
        outputSource: splitNCigar/bam_out
    ncigar_flagstat:
        type: File
        outputSource: sambamba_ncigar_flagstat/output_flagstat 
    realign_intervals:
        type: File
        outputSource: realignTargets/output_intervals
    realigned_bam:
       type: File
       outputSource: indelRealigner/output_bam
    realign_flagstat:
        type: File
        outputSource: sambamba_realign_flagstat/output_flagstat 
    base_recall_table:
        type: File
        outputSource: baseRecalibrator/recall_table
    base_recall_table_post:
        type: File
        outputSource: baseRecalibrator_bqsr/recall_table
    print_reads_bam:
        type: File
        outputSource: printReads/output_printReads 
    printReads_flagstat:
        type: File
        outputSource: sambamba_printReads_flagstat/output_flagstat  

steps:
    picard_read_groups:
        run:  ../CWL-CommandLineTools/Picard/2.18.7/AddOrReplaceReadGroups.cwl
        in:
             picard_jar: picard_jar 
             input: picard_input_bam
             ReadGroupID: picard_rg_ReadGroupID
             ReadGroupLibrary: picard_rg_ReadGroupLibrary
             ReadGroupPlatform: picard_rg_ReadGroupPlatform  
             ReadGroupPlatformUnit: picard_rg_ReadGroupPlatformUnit
             ReadGroupSampleName: picard_rg_ReadGroupSampleName
        out: [out_bam]

    sambamba_rg_flagstat:
        run: ../CWL-CommandLineTools/Sambamba/0.6.7/flagstat.cwl
        in:
             input: picard_read_groups/out_bam
        out: [output_flagstat]

    picard_mdup:
        run: ../CWL-CommandLineTools/Picard/2.18.7/MarkDuplicates.cwl
        in:
             picard_jar: picard_jar
             input: picard_read_groups/out_bam
        out: [markDups_output]
    
    sambamba_mdub_flagstat:
        run: ../CWL-CommandLineTools/Sambamba/0.6.7/flagstat.cwl
        in:
             input: picard_mdup/markDups_output
        out: [output_flagstat]

    splitNCigar:
        run:  ../CWL-CommandLineTools/GATK/3.4-46/SplitNCigarReads.cwl
        in: 
             gatk_jar: gatk_jar
             reference_sequence: reference_sequence
             input: picard_mdup/markDups_output 
             n_cigar: sncigar_n_cigar
             rf: sncigar_rf
             RMQF: sncigar_RMQF
             RMQT: sncigar_RMQT
        out: [bam_out]

    sambamba_ncigar_flagstat:
        run: ../CWL-CommandLineTools/Sambamba/0.6.7/flagstat.cwl
        in:
             input: splitNCigar/bam_out
        out: [output_flagstat]


    realignTargets:
        run:  ../CWL-CommandLineTools/GATK/3.4-46/RealignerTargetCreator.cwl
        in: 
             gatk_jar: gatk_jar
             reference_sequence: reference_sequence
             input: splitNCigar/bam_out
        out: [output_intervals]
        
    indelRealigner:
        run:  ../CWL-CommandLineTools/GATK/3.4-46/IndelRealigner.cwl
        in: 
             gatk_jar: gatk_jar
             reference_sequence: reference_sequence
             input: splitNCigar/bam_out
             targetIntervals: realignTargets/output_intervals 
        out: [output_bam]
    
    sambamba_realign_flagstat:
        run: ../CWL-CommandLineTools/Sambamba/0.6.7/flagstat.cwl
        in:
             input: indelRealigner/output_bam
        out: [output_flagstat]        

    baseRecalibrator:
        run:  ../CWL-CommandLineTools/GATK/3.4-46/BaseRecalibrator.cwl
        in: 
             gatk_jar: gatk_jar
             reference_sequence: reference_sequence
             input: indelRealigner/output_bam
             known: known_sites
        out: [recall_table]
    baseRecalibrator_bqsr:
        run:  ../CWL-CommandLineTools/GATK/3.4-46/BaseRecalibrator.cwl
        in: 
             gatk_jar: gatk_jar
             reference_sequence: reference_sequence
             input: indelRealigner/output_bam
             BQSR: baseRecalibrator/recall_table
             known: known_sites
        out: [recall_table]
    printReads:
        run:  ../CWL-CommandLineTools/GATK/3.4-46/PrintReads.cwl
        in: 
             gatk_jar: gatk_jar
             reference_sequence: reference_sequence
             input: indelRealigner/output_bam
             recall_table: baseRecalibrator_bqsr/recall_table
        out: [output_printReads]
    sambamba_printReads_flagstat:
        run: ../CWL-CommandLineTools/Sambamba/0.6.7/flagstat.cwl
        in:
             input: printReads/output_printReads 
        out: [output_flagstat]         