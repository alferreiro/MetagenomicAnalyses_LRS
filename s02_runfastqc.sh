#!/bin/bash
#===============================================================================
#
# File Name    : s02_runfastqc.sh
# Description  : This script will run fastqc
# Usage        : sbatch s02_runfastqc.sh
# Author       : Aura Ferreiro
# Version      : 1.0
# Created On   : 2023-01-27
# Last Modified: 2023-01-27
#===============================================================================
#
#Submission script for HTCF
#SBATCH --time=0-08:00:00 # days-hh:mm:ss
#SBATCH --job-name=runfastqc
#SBATCH --mem=8G
#SBATCH --output=slurmout/fastqc/x_230127runfastqc.out
#SBATCH --error=slurmout/fastqc/y_230127runfastqc.err


eval $( spack load --sh fastqc@0.11.9 )


basedir="/scratch/gdlab/alferreiro/221219_SchwartzMinionTrial_AF"
indir="${basedir}/basecalled_reads/catted_fastq"
outdir="${basedir}/fastqc_out"

# Make output dir if it doesn't exist already
mkdir -p ${outdir}


#run fastqc
fastqc -o ${outdir} -f fastq ${indir}/*fastq.gz




