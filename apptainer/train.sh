ls /mnt/datasets/cubicasa -l
pip show
nvidia-smi 

python /mnt/code/pytorch/train.py --datasetPath /mnt/datasets/cubicasa/ --batchSize 1 --numTrainingImages 8 --restore 0
