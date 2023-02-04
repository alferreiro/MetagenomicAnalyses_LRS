#!/bin/bash

#===============================================================================
# File Name    : s03_runfiltlong.sh
# Description  : Quality filter nanopore reads (no illumina reference)
# Usage        : sbatch s03_filtlong.sh
# Author       : Aura Ferreiro
# Version      : 1.0
# Created On   : Fri Jan 27 2023
# Last Modified: Fir Jan 27 2023
#===============================================================================

#SBATCH --job-name=run_filtlong
#SBATCH --array=1-9
#SBATCH --mem=2G
#SBATCH --output=slurmout/filtlong/x_230127filtlong_%a.out
#SBATCH --error=slurmout/filtlong/y_230127filtlong_%a.err


eval $( spack  load --sh filtlong@0.2.0 )

basedir="/scratch/gdlab/alferreiro/221219_SchwartzMinionTrial_AF"
indir="${basedir}/basecalled_reads/catted_fastq"
outdir="${basedir}/filtered_fastq"


#Read in samples
ID=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${basedir}/230127_SampleList.txt)


# Make outdir if it doesn't exist already
mkdir -p ${outdir}


# --target_bases flag will only have effect if sample has
# more than the indicated number.
# Other options include --min_mean_q and --min_window_q
# but because I'm dropping the worst 5% anyway, will leave.

set -x

time filtlong --min_length 1000 \
    --keep_percent 95 \
    --target_bases 750000000 \
    ${indir}/${ID}.fastq.gz | \
    gzip > ${outdir}/${ID}_filt.fastq.gz

set +x


