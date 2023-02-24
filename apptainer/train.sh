ls /mnt/datasets/cubicasa -l
conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
nvidia-smi 

#python /mnt/code/pytorch/train.py --datasetPath /mnt/datasets/cubicasa/ --batchSize 1 --numTrainingImages 8 --restore 0
