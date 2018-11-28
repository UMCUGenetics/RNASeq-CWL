class: Workflow
cwlVersion: v1.0
label: map_mdup

requirements:
    - class: StepInputExpressionRequirement
    - class: InlineJavascriptRequirement

inputs:
    star_genomeDir:
        type: Directory
        inputBinding:
          position: 1
          prefix: '--genomeDir'
    star_fastq1:
        type: File
        inputBinding:
          position: 2
          prefix: '--readFilesIn'
    star_fastq2:
        type: File
        inputBinding:
          position: 3
          prefix: ''   
    star_outFileNamePrefix:
        type: string
        inputBinding:
          position: 5
          prefix: '--outFileNamePrefix' 
    picard_jar:
        type: File
        inputBinding:
          position: 3
          prefix: '-jar'
    picard_rg_ReadGroupID:
        type: string
        inputBinding:
          position: 8
          prefix: RGID=
    picard_rg_ReadGroupLibrary:
        type: string
        inputBinding:
          position: 9
          prefix: RGLB=
    picard_rg_ReadGroupPlatform:
        type: string
        inputBinding:
          position: 10
          prefix: RGPL=
    picard_rg_ReadGroupPlatformUnit:
        type: string
        inputBinding:
          position: 11
          prefix: RGPU=
    picard_rg_ReadGroupSampleName:
        type: string
        inputBinding:
          position: 12
          prefix: RGSM=
    gatk_jar:
        type: File
        inputBinding:
          position: 2
          prefix: '-jar'
    reference_sequence:
        type: File
        secondaryFiles:
            - .fai
            - ^.dict
        inputBinding:
          prefix: --reference_sequence
          position: 5
    sncigar_n_cigar:
        type: string
        inputBinding:
          position: 11
          prefix: '-U'
    sncigar_rf:
        type: string?
        inputBinding:
          position: 8
          prefix: '-rf'
    sncigar_RMQF:
        type: int?
        inputBinding:
          position: 9
          prefix: '-RMQF'
    sncigar_RMQT:
        type: int?
        inputBinding:
          position: 10
          prefix: '-RMQT'
outputs:
    star_aligned:
        type: File
        outputSource: star_alignReads/output
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
steps:
    star_alignReads:
        run: ../CWL-CommandLineTools/STAR/2.6.0a/alignReads.cwl
        in:
             fastq1: star_fastq1  
             fastq2: star_fastq2
             genomeDir: star_genomeDir
             outFileNamePrefix: star_outFileNamePrefix
        out: [output]

    picard_read_groups:
        run:  ../CWL-CommandLineTools/Picard/2.18.7/AddOrReplaceReadGroups.cwl
        in:
             picard_jar: picard_jar 
             input: star_alignReads/output 
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
