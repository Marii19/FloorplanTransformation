#!/bin/bash

#SBATCH --mail-type=ALL
#SBATCH --mail-user=mariusz.trzeciakiewicz@hhi.fraunhofer.de

#         Output (stdout and stderr) of this job will go into a file named with SLURM_JOB_ID (%j) and the job_name (%x)
#SBATCH --output=%j_%x.out

#         Tell slurm to run the job on a single node. Always use this statement.
#SBATCH --nodes=1

#         Ask slurm to run at most 1 task (slurm task == OS process). A task (process) might launch subprocesses/threads.
#SBATCH --ntasks=1

#         Max number of cpus per process (threads/subprocesses) is 16. Seems reasonable with 4 GPUs on a 64 core machine.
#SBATCH --cpus-per-task=16

#         Request from the generic resources 2 GPU 
#SBACH --gpus=2

#         Request RAM for your job
#SBATCH --mem=32G

#####################################################################################

# This included file contains the definition for $LOCAL_JOB_DIR to be used locally on the node.
source "/etc/slurm/local_job_dir.sh"

# Launch the apptainer image with --nv for nvidia support. Two bind mounts are used: 
# - One for the ImageNet dataset and 
# - One for the results (e.g. checkpoint data that you may store in $LOCAL_JOB_DIR on the node
echo export PYTHONWARNINGS="ignore"
apptainer run --nv --bind ${DATAPOOL3}/datasets/bimkit:/mnt/datasets
    --bind ${LOCAL_JOB_DIR}:/mnt/output $SCRIPT_DIR/train_segmentation.sif bash "/train.sh"

# This command copies all results generated in $LOCAL_JOB_DIR back to the submit folder regarding the job id.
cp -r ${LOCAL_JOB_DIR} ${SLURM_SUBMIT_DIR}/${SLURM_JOB_ID}