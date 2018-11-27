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
        run:  ../CWL-CommandLineTools/Picard/2.18.7/MarkDuplicates.cwl
        in:
             picard_jar: picard_jar
             input: picard_read_groups/out_bam
        out: [markDups_output]
    
    sambamba_mdub_flagstat:
        run: ../CWL-CommandLineTools/Sambamba/0.6.7/flagstat.cwl
        in:
            input: picard_mdup/markDups_output
        out: [output_flagstat]
