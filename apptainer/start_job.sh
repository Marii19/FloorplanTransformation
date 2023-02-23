#!/bin/bash

# Params:
# $1: partition (cvg or testing; gpu3 possible with lower priority)
# $2: bash training script's name (e.g. train for train.sh in this script's folder)
# $3: training config file (e.g. base.yaml)
# $4: job name (e.g. training_base) - if "auto", changed to "train_<config_name>"
# $5: job comment, saved to comment.txt in output folder
# $6: [optional] folder with previous checkpoints to resume training from


if [ "$#" -lt 5 ] || [ "$#" -gt 6 ]; then
    echo "Number of params must be 5 or 6."
    exit 1
fi


SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TRAINING_SCRIPT="$SCRIPT_DIR/$2.sh"

CFG_NAME=`basename $3 | sed 's/.yaml//g'`
[[ $4 == "auto" ]] && JOB_NAME="train_${CFG_NAME}" || JOB_NAME="$4"


sbatch -p $1 <<EOH
#!/bin/bash

#SBATCH --mail-type=ALL
#SBATCH --mail-user=aleixo.cambeiro@hhi.fraunhofer.de
#SBATCH --job-name=${JOB_NAME}
#SBATCH --output=%j_%x.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --gpus=1
#SBATCH --mem=64G

source "/etc/slurm/local_job_dir.sh"

echo  \${LOCAL_JOB_DIR}"/job_results"
mkdir -p \${LOCAL_JOB_DIR}"/job_results"

if [ "$6" == "" ]
then
   echo "nothing to copy"
else
    cp -r \${SLURM_SUBMIT_DIR}/output/$6 \${LOCAL_JOB_DIR}"/ckpt_dir"
fi

echo $5 > \${LOCAL_JOB_DIR}"/job_results/comment.txt"
ls -l \${LOCAL_JOB_DIR}

echo export PYTHONWARNINGS="ignore"
apptainer run --nv --bind U-Net:/mnt/code --bind ${DATAPOOL3}/datasets/bimkit:/mnt/datasets \
    --bind \${LOCAL_JOB_DIR}:/mnt/output $SCRIPT_DIR/train_segmentation.sif bash $TRAINING_SCRIPT $3

cd \${LOCAL_JOB_DIR}
ls -l
tar -cf ${JOB_NAME}_\${SLURM_JOB_ID}.tar -C job_results .
cp ${JOB_NAME}_\${SLURM_JOB_ID}.tar \${SLURM_SUBMIT_DIR}/output
rm -rf \${LOCAL_JOB_DIR}/job_results

mkdir -p \${SLURM_SUBMIT_DIR}/output/${JOB_NAME}_\${SLURM_JOB_ID}
tar -xvf \${SLURM_SUBMIT_DIR}/output/${JOB_NAME}_\${SLURM_JOB_ID}.tar \
    -C \${SLURM_SUBMIT_DIR}/output/${JOB_NAME}_\${SLURM_JOB_ID}
rm \${SLURM_SUBMIT_DIR}/output/${JOB_NAME}_\${SLURM_JOB_ID}.tar
mv \${SLURM_SUBMIT_DIR}/\${SLURM_JOB_ID}*.out \${SLURM_SUBMIT_DIR}/output/${JOB_NAME}_\${SLURM_JOB_ID}
EOH
