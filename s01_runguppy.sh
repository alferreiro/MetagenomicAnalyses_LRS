#!/bin/bash
#===============================================================================
#
# File Name    : s01_guppy.sh
# Description  : This script will run the GPU guppy basecaller
# Usage        : sbatch s01_guppy.sh
# Author       : Luke Diorio-Toth, ldiorio-toth@wustl.edu
# Version      : 1.0
# Created On   : Wed Mar 11 13:31:51 CDT 2020
# Modified On  : Wed Mar 11 13:31:51 CDT 2020
#===============================================================================
#
#SBATCH -p gpu
#SBATCH --job-name=guppy
#SBATCH --cpus-per-task=12
#SBATCH --gres=gpu:1
#SBATCH --mem=10G
#SBATCH --output=slurmout/guppy/z_guppy_%a.out
#SBATCH --error=slurmout/guppy/z_guppy_%a.err


# -p and -gres options are to request a gpu node (and specifically one graphics card)
# Guppy runs 100-1000x faster on a gpu node than a cpu node.
# Not sure why --cpus-per-task is still flagged. It gets called in guppy below.


basedir="/scratch/gdlab/alferreiro/221219_SchwartzMinionTrial_AF"
indir="${basedir}/fast5"
outdir="${basedir}/basecalled_reads"


eval $( spack load --sh ont-guppy@6.1.7-cuda )



# Make output directory if it doesn't exist yet.
mkdir -p ${outdir}


# When calling guppy, you can either specify the flowcell and library kit, e.g.:
#                         -f FLO-MIN106 -k SQK-LSK109
# OR you can just specify the corresponding configuration file, e.g.:
#                         -c dna_r9.4.1_450bps_sup.cfg
# How do you identify the appropriate .cfg file for your flowcell/kit? You can use:
#                         $ guppy_basecaller --print_workflows
# Note that there are suffixes _sup and _hac. hac refers to high accuracy model,
# while sup refers to super high accuracy model (guppy 5.0.7 and later). This is
# a lot more computationally intensive, but we have handy GPU node to handle this.
# In addition, the barcode kit must be supplied.

cfg="dna_r9.4.1_450bps_sup.cfg"
barcodes="EXP-NBD104"


set -x

guppy_basecaller -i ${indir} \
    -s ${outdir} \
    --config ${cfg} \
    --barcode_kits ${barcodes} \
    --gpu_runners_per_device 24 \
    --num_callers ${SLURM_CPUS_PER_TASK} \
    --compress_fastq \
    --trim_barcodes \
    --disable_qscore_filtering \
    -x cuda:0

set +x


