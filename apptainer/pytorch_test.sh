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

source "/etc/slurm/local_job_dir.sh"
mkdir -p "${LOCAL_JOB_DIR}/job_results"
echo "${LOCAL_JOB_DIR}/job_results"

echo export PYTHONWARNINGS="ignore"
apptainer run --nv --bind git/FloorplanTransformation:/mnt/code --bind ${DATAPOOL3}/datasets/cubicasa_small:/mnt/datasets/cubicasa --bind ${LOCAL_JOB_DIR}:/mnt/output git/FloorplanTransformation/apptainer/pytorch_test.sif bash /mnt/code/apptainer/train.sh
# apptainer run --nv ./git/FloorplanTransformation/apptainer/pytorch.sif

cd ${LOCAL_JOB_DIR}

tar -cf pytorch_${SLURM_JOB_ID}.tar -C job_results .
cp pytorch_${SLURM_JOB_ID}.tar ${SLURM_SUBMIT_DIR}/output
rm -rf ${LOCAL_JOB_DIR}/job_results

mkdir -p ${SLURM_SUBMIT_DIR}/output/pytorch_${SLURM_JOB_ID}
tar -xvf ${SLURM_SUBMIT_DIR}/output/pytorch_${SLURM_JOB_ID}.tar \
    -C ${SLURM_SUBMIT_DIR}/output/pytorch_${SLURM_JOB_ID}
rm ${SLURM_SUBMIT_DIR}/output/pytorch_${SLURM_JOB_ID}.tar
mv ${SLURM_SUBMIT_DIR}/${SLURM_JOB_ID}*.out ${SLURM_SUBMIT_DIR}/output/pytorch_${SLURM_JOB_ID}