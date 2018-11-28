#!/bin/bash

## Submission parameters
#$ -q all.q
#$ -e VC.err
#$ -V
#$ -cwd
#$ -pe threaded 4
#$ -l h_vmem=20G
#$ -M t.schafers@umcutrecht.nl
#$ -m beas

source activate rnaseq

$RABIX rnaseq_pre_process.cwl rnaseq_pre_process.yml
