ls /mnt/datasets/cubicasa -l
nvidia-smi 
pip install tensorflow==2.8.0 
python /mnt/code/pytorch/train.py --datasetPath /mnt/datasets/cubicasa/ --batchSize 1 --numTrainingImages 8 --restore 0
