#!/bin/bash

#===============================================================================
# File Name    : s04_runmetaflye.sh
# Description  : Assembles bacterial genomes from nanopore reads
# Usage        : sbatch s04_runmetaflye.sh
# Author       : Aura Ferreiro
# Version      : 1.0
# Created On   : Friday Jan 27 2023
# Last Modified: Friday Jan 27 2023
#===============================================================================

#SBATCH --job-name=metaflye
#SBATCH --time=2-00:00:00 #days-hh:mm:ss
#SBATCH --array=1-9
#SBATCH --cpus-per-task=4
#SBATCH --mem=12G
#SBATCH --output=slurmout/metaflye/x_230127flye_%a_%A.out
#SBATCH --error=slurmout/metaflye/y_230127flye_%a_%A.out

eval $( spack load --sh py-flye@2.9 )


basedir="/scratch/gdlab/alferreiro/221219_SchwartzMinionTrial_AF"
indir="${basedir}/filtered_fastq"
outdir="${basedir}/metaflye_out"



ID=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${basedir}/230127_SampleList.txt)


# Make outdir if it doesn't exist
mkdir -p ${outdir}

# Base-called with Guppy5+ using sup models (vs. hac model), so will
# use --nano-hq flag to set filepaths, rather than the standard
# --nano-raw. The difference is the expected error rate (<5% vs <20%
# error rate.

set -x
time flye \
    --nano-hq ${indir}/${ID}_filt.fastq.gz \
    --out-dir ${outdir}/${ID} \
    --threads ${SLURM_CPUS_PER_TASK} \
    --meta

set +x





