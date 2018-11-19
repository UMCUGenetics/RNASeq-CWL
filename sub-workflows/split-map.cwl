{
    "class": "Workflow",
    "cwlVersion": "v1.0",
    "id": "rnaseq_gatk_bp",
    "label": "RNAseq-GATK-BP",
    "$namespaces": {
        "sbg": "https://www.sevenbridges.com/"
    },
    "inputs": [
        {
            "id": "outSamType",
            "type": "string?",
            "sbg:exposed": true
        },
        {
            "id": "genomeDir",
            "type": "Directory?",
            "sbg:x": 0,
            "sbg:y": 213.71875
        },
        {
            "id": "fastq2",
            "type": "File?",
            "sbg:x": 0,
            "sbg:y": 320.578125
        },
        {
            "id": "fastq1",
            "type": "File?",
            "sbg:x": 0,
            "sbg:y": 427.4375
        },
        {
            "id": "createIndex",
            "type": "string?",
            "sbg:exposed": true
        },
        {
            "id": "java_arg",
            "type": "string",
            "sbg:exposed": true
        },
        {
            "id": "outputFileName_markDups",
            "type": "string",
            "sbg:exposed": true
        },
        {
            "id": "jar",
            "type": "File",
            "sbg:x": 251.328125,
            "sbg:y": 199.71875
        },
        {
            "id": "metricsFile",
            "type": "string?",
            "sbg:x": 251.328125,
            "sbg:y": 92.859375
        },
        {
            "id": "CREATE_INDEX",
            "type": "string",
            "sbg:exposed": true
        },
        {
            "id": "ReadGroupID",
            "type": "string",
            "sbg:exposed": true
        },
        {
            "id": "ReadGroupLibrary",
            "type": "string",
            "sbg:exposed": true
        },
        {
            "id": "ReadGroupPlatform",
            "type": "string",
            "sbg:exposed": true
        },
        {
            "id": "ReadGroupPlatformUnit",
            "type": "string",
            "sbg:exposed": true
        },
        {
            "id": "ReadGroupSampleName",
            "type": "string",
            "sbg:x": 0,
            "sbg:y": 106.859375
        },
        {
            "id": "gatk_jar",
            "type": "File",
            "sbg:x": 1070.148193359375,
            "sbg:y": 267.1484375
        },
        {
            "id": "Reference",
            "type": "File",
            "sbg:x": 0,
            "sbg:y": 0
        },
        {
            "id": "java_args",
            "type": "string",
            "sbg:exposed": true
        },
        {
            "id": "OUTPUT",
            "type": "string",
            "sbg:exposed": true
        },
        {
            "id": "N_CIGAR",
            "type": "string",
            "sbg:exposed": true
        },
        {
            "id": "rf",
            "type": "string?",
            "sbg:exposed": true
        },
        {
            "id": "RMQF",
            "type": "int?",
            "sbg:exposed": true
        },
        {
            "id": "RMQT",
            "type": "int?",
            "sbg:exposed": true
        }
    ],
    "outputs": [
        {
            "id": "markDups_output_index",
            "outputSource": [
                "picard__mark_duplicates/markDups_output_index"
            ],
            "type": "File",
            "sbg:x": 824.5075073242188,
            "sbg:y": 267.1484375
        },
        {
            "id": "bam_out",
            "outputSource": [
                "gatk_splitncigarreads/bam_out"
            ],
            "type": "File?",
            "sbg:x": 1572.09228515625,
            "sbg:y": 197.65634155273438
        }
    ],
    "steps": [
        {
            "id": "_s_t_a_r_alignr_reads",
            "in": [
                {
                    "id": "fastq1",
                    "source": "fastq1"
                },
                {
                    "id": "fastq2",
                    "source": "fastq2"
                },
                {
                    "id": "genomeDir",
                    "source": "genomeDir"
                },
                {
                    "id": "outSamType",
                    "source": "outSamType"
                }
            ],
            "out": [
                {
                    "id": "output"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.0",
                "$namespaces": {
                    "sbg": "https://www.sevenbridges.com"
                },
                "id": "_s_t_a_r_alignr_reads",
                "baseCommand": [
                    "STAR"
                ],
                "inputs": [
                    {
                        "id": "fastq1",
                        "type": "File?",
                        "inputBinding": {
                            "position": 2,
                            "prefix": "--readFilesIn"
                        }
                    },
                    {
                        "id": "fastq2",
                        "type": "File?",
                        "inputBinding": {
                            "position": 3,
                            "prefix": ""
                        }
                    },
                    {
                        "id": "genomeDir",
                        "type": "Directory?",
                        "inputBinding": {
                            "position": 4,
                            "prefix": "--genomeDir"
                        }
                    },
                    {
                        "id": "outSamType",
                        "type": "string?",
                        "inputBinding": {
                            "position": 4,
                            "prefix": "--outSAMtype",
                            "shellQuote": false
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "output",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "Aligned.sortedByCoord.out.bam"
                        },
                        "secondaryFiles": [
                            ".out",
                            ".tab"
                        ]
                    }
                ],
                "label": "STAR-alignReads",
                "arguments": [
                    {
                        "position": 0,
                        "prefix": "--runMode",
                        "valueFrom": "alignReads"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    }
                ]
            },
            "label": "STAR-alignReads",
            "sbg:x": 251.328125,
            "sbg:y": 320.578125
        },
        {
            "id": "sort",
            "in": [
                {
                    "id": "input",
                    "source": "picard__mark_duplicates/markDups_output"
                }
            ],
            "out": [
                {
                    "id": "output_bam"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.0",
                "baseCommand": [
                    "sambamba",
                    "sort"
                ],
                "inputs": [
                    {
                        "id": "input",
                        "type": "File",
                        "inputBinding": {
                            "position": 1
                        },
                        "doc": "input.bam"
                    }
                ],
                "outputs": [
                    {
                        "id": "output_bam",
                        "type": "File",
                        "outputBinding": {
                            "glob": "$(inputs.input.nameroot).sorted.bam"
                        },
                        "secondaryFiles": [
                            ".bai"
                        ]
                    }
                ],
                "label": "sambamba sort, tool for sorting a BAM file.",
                "arguments": [
                    {
                        "position": 0,
                        "prefix": "--nthreads",
                        "valueFrom": "$(runtime.cores)"
                    },
                    {
                        "position": 0,
                        "prefix": "--memory-limit",
                        "valueFrom": "$(runtime.ram)MiB"
                    },
                    {
                        "position": 0,
                        "prefix": "--tmpdir",
                        "valueFrom": "$(runtime.tmpdir)"
                    },
                    {
                        "position": 0,
                        "prefix": "--out",
                        "valueFrom": "$(inputs.input.nameroot).sorted.bam"
                    }
                ],
                "requirements": [
                    {
                        "class": "InlineJavascriptRequirement"
                    }
                ]
            },
            "label": "sambamba sort, tool for sorting a BAM file.",
            "sbg:x": 824.5075073242188,
            "sbg:y": 160.2890625
        },
        {
            "id": "picard__mark_duplicates",
            "in": [
                {
                    "id": "createIndex",
                    "source": "createIndex"
                },
                {
                    "id": "inputFileName_markDups",
                    "source": [
                        "_s_t_a_r_alignr_reads/output"
                    ]
                },
                {
                    "id": "java_arg",
                    "source": "java_arg"
                },
                {
                    "id": "metricsFile",
                    "source": "metricsFile"
                },
                {
                    "id": "outputFileName_markDups",
                    "source": "outputFileName_markDups"
                },
                {
                    "id": "jar",
                    "source": "jar"
                }
            ],
            "out": [
                {
                    "id": "markDups_output"
                },
                {
                    "id": "markDups_output_index"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.0",
                "$namespaces": {
                    "sbg": "https://www.sevenbridges.com"
                },
                "baseCommand": [
                    "java"
                ],
                "inputs": [
                    {
                        "id": "barcodeTag",
                        "type": "string?",
                        "inputBinding": {
                            "position": 10,
                            "prefix": "BARCODE_TAG="
                        },
                        "doc": "Barcode SAM tag (ex. BC for 10X Genomics) Default value null"
                    },
                    {
                        "id": "comment",
                        "type": "File[]?",
                        "inputBinding": {
                            "position": 17
                        },
                        "doc": "Comment(s) to include in the output files header. Default value null. This option may be specified 0 or more times"
                    },
                    {
                        "default": "true",
                        "id": "createIndex",
                        "type": "string?",
                        "inputBinding": {
                            "position": 20,
                            "prefix": "CREATE_INDEX="
                        },
                        "doc": "Whether to create a BAM index when writing a coordinate-sorted BAM file. Default value false. This option can be set to 'null' to clear the default value. Possible values {true, false}"
                    },
                    {
                        "id": "groupCommandLine",
                        "type": "string?",
                        "inputBinding": {
                            "position": 15,
                            "prefix": "PROGRAM_GROUP_COMMAND_LINE="
                        },
                        "doc": "Value of CL tag of PG record to be created. If not supplied the command line will be detected automatically. Default value null"
                    },
                    {
                        "id": "groupCommandName",
                        "type": "string?",
                        "inputBinding": {
                            "position": 16,
                            "prefix": "PROGRAM_GROUP_NAME="
                        },
                        "doc": "Value of PN tag of PG record to be created. Default value MarkDuplicates. This option can be set to 'null' to clear the default value"
                    },
                    {
                        "id": "groupVersion",
                        "type": "string?",
                        "inputBinding": {
                            "position": 14,
                            "prefix": "PROGRAM_GROUP_VERSION="
                        },
                        "doc": "Value of VN tag of PG record to be created. If not specified, the version will be detected automatically. Default value null"
                    },
                    {
                        "id": "inputFileName_markDups",
                        "type": "File[]",
                        "inputBinding": {
                            "position": 4,
                            "prefix": "INPUT="
                        },
                        "doc": "One or more input SAM or BAM files to analyze. Must be coordinate sorted. Default value null. This option may be specified 0 or more times"
                    },
                    {
                        "default": "-Xmx4g",
                        "id": "java_arg",
                        "type": "string",
                        "inputBinding": {
                            "position": 1
                        }
                    },
                    {
                        "id": "maxFileHandles",
                        "type": "int?",
                        "inputBinding": {
                            "position": 8,
                            "prefix": "MAX_FILE_HANDLES_FOR_READ_ENDS_MAP="
                        },
                        "doc": "Maximum number of file handles to keep open when spilling read ends to disk. Set this number a little lower than the per-process maximum number of file that may be open. This number can be found by executing the 'ulimit -n' command on a Unix system. Default value 8000. This option can be set to 'null' to clear the default value"
                    },
                    {
                        "id": "metricsFile",
                        "type": "string?",
                        "inputBinding": {
                            "position": 6,
                            "prefix": "METRICS_FILE="
                        },
                        "doc": "File to write duplication metrics to Required"
                    },
                    {
                        "id": "outputFileName_markDups",
                        "type": "string",
                        "inputBinding": {
                            "position": 5,
                            "prefix": "OUTPUT="
                        },
                        "doc": "The output file to write marked records to Required"
                    },
                    {
                        "id": "pixelDistance",
                        "type": "int?",
                        "inputBinding": {
                            "position": 19,
                            "prefix": "OPTICAL_DUPLICATE_PIXEL_DISTANCE="
                        },
                        "doc": "The maximum offset between two duplicte clusters in order to consider them optical duplicates. This should usually be set to some fairly small number (e.g. 5-10 pixels) unless using later versions of the Illumina pipeline that multiply pixel values by 10, in which case 50-100 is more normal. Default value 100. This option can be set to 'null' to clear the default value"
                    },
                    {
                        "id": "readOneBarcodeTag",
                        "type": "string?",
                        "inputBinding": {
                            "position": 11,
                            "prefix": "READ_ONE_BARCODE_TAG="
                        },
                        "doc": "Read one barcode SAM tag (ex. BX for 10X Genomics) Default value null"
                    },
                    {
                        "id": "readSorted",
                        "type": "string?",
                        "inputBinding": {
                            "position": 22,
                            "prefix": "ASSUME_SORTED="
                        },
                        "doc": "If true, assume that the input file is coordinate sorted even if the header says otherwise. Default value false. This option can be set to 'null' to clear the default value. Possible values {true, false}"
                    },
                    {
                        "id": "readTwoBarcodeTag",
                        "type": "string?",
                        "inputBinding": {
                            "position": 12,
                            "prefix": "READ_TWO_BARCODE_TAG="
                        },
                        "doc": "Read two barcode SAM tag (ex. BX for 10X Genomics) Default value null"
                    },
                    {
                        "id": "recordId",
                        "type": "string?",
                        "inputBinding": {
                            "position": 13,
                            "prefix": "PROGRAM_RECORD_ID="
                        },
                        "doc": "The program record ID for the @PG record(s) created by this program. Set to null to disable PG record creation. This string may have a suffix appended to avoid collision with other program record IDs. Default value MarkDuplicates. This option can be set to 'null' to clear the default value"
                    },
                    {
                        "id": "regularExpression",
                        "type": "string?",
                        "inputBinding": {
                            "position": 18,
                            "prefix": "READ_NAME_REGEX="
                        },
                        "doc": "Regular expression that can be used to parse read names in the incoming SAM file. Read names are parsed to extract three variables tile/region, x coordinate and y coordinate. These values are used to estimate the rate of optical duplication in order to give a more accurate estimated library size. Set this option to null to disable optical duplicate detection. The regular expression should contain three capture groups for the three variables, in order. It must match the entire read name. Note that if the default regex is specified, a regex match is not actually done, but instead the read name is split on colon character. For 5 element names, the 3rd, 4th and 5th elements are assumed to be tile, x and y values. For 7 element names (CASAVA 1.8), the 5th, 6th, and 7th elements are assumed to be tile, x and y values. Default value [a-zA-Z0-9]+:[0-9]:([0-9]+):([0-9]+):([0-9]+).*. This option can be set to 'null' to clear the default value"
                    },
                    {
                        "id": "removeDuplicates",
                        "type": "string?",
                        "inputBinding": {
                            "position": 7,
                            "prefix": "REMOVE_DUPLICATES="
                        },
                        "doc": "If true do not write duplicates to the output file instead of writing them with appropriate flags set. Default value false. This option can be set to 'null' to clear the default value. Possible values {true, false}"
                    },
                    {
                        "id": "sortRatio",
                        "type": "double?",
                        "inputBinding": {
                            "position": 9,
                            "prefix": "SORTING_COLLECTION_SIZE_RATIO="
                        },
                        "doc": "This number, plus the maximum RAM available to the JVM, determine the memory footprint used by some of the sorting collections. If you are running out of memory, try reducing this number. Default value 0.25. This option can be set to 'null' to clear the default value"
                    },
                    {
                        "id": "tmpdir",
                        "type": "string?",
                        "inputBinding": {
                            "position": 21,
                            "prefix": "TMP_DIR="
                        },
                        "doc": "Default value null. This option may be specified 0 or more times."
                    },
                    {
                        "id": "jar",
                        "type": "File?",
                        "inputBinding": {
                            "position": 2,
                            "prefix": "-jar"
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "markDups_output",
                        "type": "File",
                        "outputBinding": {
                            "glob": "$(inputs.outputFileName_markDups)"
                        }
                    },
                    {
                        "id": "markDups_output_index",
                        "type": "File",
                        "outputBinding": {
                            "glob": "$(\"*.bai\")"
                        }
                    }
                ],
                "arguments": [
                    {
                        "position": 4,
                        "valueFrom": "VALIDATION_STRINGENCY=SILENT"
                    },
                    {
                        "position": 3,
                        "prefix": "",
                        "shellQuote": false,
                        "valueFrom": "MarkDuplicates"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "InlineJavascriptRequirement"
                    }
                ],
                "sbg:license": "",
                "sbg:toolAuthor": "",
                "sbg:toolkit": "Picard",
                "sbg:toolkitVersion": "MarkDuplicates",
                "sbg:wrapperAuthor": "",
                "sbg:wrapperLicense": "Apache 2.0"
            },
            "sbg:x": 453.8392333984375,
            "sbg:y": 199.71875
        },
        {
            "id": "picard__add_or_replace_read_groups",
            "in": [
                {
                    "id": "input",
                    "source": [
                        "sort/output_bam"
                    ]
                },
                {
                    "id": "java_args",
                    "default": "-Xmx4g"
                },
                {
                    "id": "output",
                    "default": "Test.rg.bam"
                },
                {
                    "id": "ReadGroupID",
                    "default": "agdg",
                    "source": "ReadGroupID"
                },
                {
                    "id": "ReadGroupLibrary",
                    "default": "fdgdfg",
                    "source": "ReadGroupLibrary"
                },
                {
                    "id": "ReadGroupPlatform",
                    "default": "afgafg",
                    "source": "ReadGroupPlatform"
                },
                {
                    "id": "ReadGroupPlatformUnit",
                    "default": "afdgsfg",
                    "source": "ReadGroupPlatformUnit"
                },
                {
                    "id": "ReadGroupSampleName",
                    "default": "fGADFG",
                    "source": "ReadGroupSampleName"
                },
                {
                    "id": "CREATE_INDEX",
                    "default": "true",
                    "source": "CREATE_INDEX"
                },
                {
                    "id": "jar",
                    "source": "jar"
                }
            ],
            "out": [
                {
                    "id": "out_bam"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.0",
                "$namespaces": {
                    "sbg": "https://www.sevenbridges.com"
                },
                "id": "picard__add_or_replace_read_groups",
                "baseCommand": [
                    "java"
                ],
                "inputs": [
                    {
                        "id": "input",
                        "type": "File[]",
                        "inputBinding": {
                            "position": 3,
                            "prefix": "INPUT=",
                            "separate": false
                        }
                    },
                    {
                        "id": "java_args",
                        "type": "string",
                        "inputBinding": {
                            "position": 1
                        }
                    },
                    {
                        "id": "output",
                        "type": "string",
                        "inputBinding": {
                            "position": 4,
                            "prefix": "OUTPUT=",
                            "separate": false
                        }
                    },
                    {
                        "id": "SortOrder",
                        "type": "string?",
                        "inputBinding": {
                            "position": 6,
                            "prefix": "SORT_ORDER=",
                            "separate": false
                        }
                    },
                    {
                        "id": "ReadGroupID",
                        "type": "string",
                        "inputBinding": {
                            "position": 7,
                            "prefix": "RGID=",
                            "separate": false
                        }
                    },
                    {
                        "id": "ReadGroupLibrary",
                        "type": "string",
                        "inputBinding": {
                            "position": 8,
                            "prefix": "RGLB=",
                            "separate": false
                        }
                    },
                    {
                        "id": "ReadGroupPlatform",
                        "type": "string",
                        "inputBinding": {
                            "position": 9,
                            "prefix": "RGPL=",
                            "separate": false
                        }
                    },
                    {
                        "id": "ReadGroupPlatformUnit",
                        "type": "string",
                        "inputBinding": {
                            "position": 10,
                            "prefix": "RGPU=",
                            "separate": false
                        }
                    },
                    {
                        "id": "ReadGroupSampleName",
                        "type": "string",
                        "inputBinding": {
                            "position": 11,
                            "prefix": "RGSM=",
                            "separate": false
                        }
                    },
                    {
                        "id": "ReadGroupSequenceCenter",
                        "type": "string?",
                        "inputBinding": {
                            "position": 12,
                            "prefix": "RGCN=",
                            "separate": false
                        }
                    },
                    {
                        "id": "ReadGroupDescription",
                        "type": "string?",
                        "inputBinding": {
                            "position": 13,
                            "prefix": "RGDS=",
                            "separate": false
                        }
                    },
                    {
                        "id": "ReadGroupRunDate",
                        "type": "string?",
                        "inputBinding": {
                            "position": 14,
                            "prefix": "RGDT=",
                            "separate": false
                        }
                    },
                    {
                        "id": "ReadGroupPredictedInsertSize",
                        "type": "string?",
                        "inputBinding": {
                            "position": 15,
                            "prefix": "RGPI=",
                            "separate": false
                        }
                    },
                    {
                        "id": "ReadGroupProgramGroup",
                        "type": "string?",
                        "inputBinding": {
                            "position": 16,
                            "prefix": "RGPG=",
                            "separate": false
                        }
                    },
                    {
                        "id": "ReadGroupPlatformModel",
                        "type": "string?",
                        "inputBinding": {
                            "position": 17,
                            "prefix": "RGPM=",
                            "separate": false
                        }
                    },
                    {
                        "id": "CREATE_INDEX",
                        "type": "string",
                        "inputBinding": {
                            "position": 5,
                            "prefix": "CREATE_INDEX="
                        }
                    },
                    {
                        "id": "jar",
                        "type": "File?",
                        "inputBinding": {
                            "position": 2,
                            "prefix": "-jar"
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "out_bam",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "$(inputs.output)"
                        }
                    }
                ],
                "doc": "CWL implementation of Picard's AddOrReplaceReadGroups subcomand",
                "label": "picard-AddOrReplaceReadGroups",
                "arguments": [
                    {
                        "position": 3,
                        "prefix": "",
                        "shellQuote": false,
                        "valueFrom": "AddOrReplaceReadGroups"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "InlineJavascriptRequirement"
                    }
                ],
                "sbg:license": "",
                "sbg:toolAuthor": "",
                "sbg:toolkit": "Picard",
                "sbg:toolkitVersion": "AddOrReplaceReadGroups",
                "sbg:wrapperAuthor": "TIlman Schaefers",
                "sbg:wrapperLicense": "MIT"
            },
            "label": "picard-AddOrReplaceReadGroups",
            "sbg:x": 1070.148193359375,
            "sbg:y": 146.2890625
        },
        {
            "id": "gatk_splitncigarreads",
            "in": [
                {
                    "id": "java_args",
                    "source": "java_args"
                },
                {
                    "id": "gatk_jar",
                    "source": "gatk_jar"
                },
                {
                    "id": "Reference",
                    "source": "Reference"
                },
                {
                    "id": "INPUT",
                    "source": "picard__add_or_replace_read_groups/out_bam"
                },
                {
                    "id": "OUTPUT",
                    "source": "OUTPUT"
                },
                {
                    "id": "N_CIGAR",
                    "source": "N_CIGAR"
                },
                {
                    "id": "rf",
                    "source": "rf"
                },
                {
                    "id": "RMQF",
                    "source": "RMQF"
                },
                {
                    "id": "RMQT",
                    "source": "RMQT"
                }
            ],
            "out": [
                {
                    "id": "bam_out"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.0",
                "$namespaces": {
                    "sbg": "https://www.sevenbridges.com"
                },
                "id": "gatk_splitncigarreads",
                "baseCommand": [
                    "java"
                ],
                "inputs": [
                    {
                        "id": "java_args",
                        "type": "string",
                        "inputBinding": {
                            "position": 0
                        }
                    },
                    {
                        "id": "gatk_jar",
                        "type": "File",
                        "inputBinding": {
                            "position": 2,
                            "prefix": "-jar",
                            "shellQuote": false
                        }
                    },
                    {
                        "id": "Reference",
                        "type": "File",
                        "inputBinding": {
                            "position": 4,
                            "prefix": "-R"
                        }
                    },
                    {
                        "id": "INPUT",
                        "type": "File",
                        "inputBinding": {
                            "position": 5,
                            "prefix": "-I"
                        }
                    },
                    {
                        "id": "OUTPUT",
                        "type": "string",
                        "inputBinding": {
                            "position": 6,
                            "prefix": "-o"
                        }
                    },
                    {
                        "id": "N_CIGAR",
                        "type": "string",
                        "inputBinding": {
                            "position": 11,
                            "prefix": "-U"
                        }
                    },
                    {
                        "id": "rf",
                        "type": "string?",
                        "inputBinding": {
                            "position": 8,
                            "prefix": "-rf"
                        }
                    },
                    {
                        "id": "RMQF",
                        "type": "int?",
                        "inputBinding": {
                            "position": 9,
                            "prefix": "-RMQF"
                        }
                    },
                    {
                        "id": "RMQT",
                        "type": "int?",
                        "inputBinding": {
                            "position": 10,
                            "prefix": "-RMQT"
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "bam_out",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "$(inputs.output)"
                        }
                    }
                ],
                "label": "GATK-SplitNCigarReads",
                "arguments": [
                    {
                        "position": 3,
                        "prefix": "-T",
                        "valueFrom": "SplitNCigarReads"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "InlineJavascriptRequirement"
                    }
                ],
                "sbg:license": "",
                "sbg:toolAuthor": "",
                "sbg:toolkit": "GATK",
                "sbg:toolkitVersion": "SplitNCigarReads",
                "sbg:wrapperAuthor": "Tilman Schaefers",
                "sbg:wrapperLicense": "MIT"
            },
            "label": "GATK-SplitNCigarReads",
            "sbg:x": 1359.8154296875,
            "sbg:y": 199.71875
        }
    ],
    "requirements": []
}