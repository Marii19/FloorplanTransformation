[[ -d /mnt/output/ckpt_dir ]] && CKPT_OPT="TRAINING.CKPT_DIR /mnt/output/ckpt_dir" || CKPT_OPT=""

python mnt/Floorp/train.py --dataset-path 
