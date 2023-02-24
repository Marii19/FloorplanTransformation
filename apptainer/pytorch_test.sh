#!/bin/bash

#SBATCH --mail-type=ALL
#SBATCH --mail-user=mariusz.trzeciakiewicz@hhi.fraunhofer.de

#         stdout and stderr of this job will go into a file named like the job (%x) with SLURM_JOB_ID (%j)
#SBATCH --output=%j.out

#         ask slurm to run at most 1 task (slurm task == OS process) which might have subprocesses/threads 
#SBATCH --ntasks=1

#         number of cpus/task (threads/subprocesses). 8 is enough. 16 seems a reasonable max. with 4 GPUs on a 72 core machine.
#SBATCH --cpus-per-task=1

#         request from the generic resources 
#SBATCH --gres=gpu:1

#SBATCH --mem=2GB


apptainer run --nv ./git/FloorplanTransformation/apptainer/pytorch.sif
