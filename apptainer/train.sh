ls /mnt/datasets/cubicasa -l
pip show tensorflow
nvidia-smi 

python /mnt/code/pytorch/train.py --datasetPath /mnt/datasets/cubicasa/ --batchSize 1 --numTrainingImages 8 --restore 0
