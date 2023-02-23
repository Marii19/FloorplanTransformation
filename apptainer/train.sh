[[ -d /mnt/output/ckpt_dir ]] && CKPT_OPT="TRAINING.CKPT_DIR /mnt/output/ckpt_dir" || CKPT_OPT=""

python /pytorch/train.py --dataset-path 
