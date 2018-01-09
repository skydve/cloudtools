#!bash ??

sudo apt update
sudo apt install curl
sudo apt install git

sudo apt install docker.io
sudo usermod -a -G docker $USER

# sudo apt -y upgrade --allow -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
bash Anaconda3-5.0.1-Linux-x86_64.sh -b

cd
git clone https://github.com/fastai/fastai.git
cd fastai/
echo 'export PATH=~/anaconda3/bin:$PATH' >> ~/.bashrc
export PATH=~/anaconda3/bin:$PATH
source ~/.bashrc
conda env update
echo 'source activate fastai' >> ~/.bashrc
source activate fastai
source ~/.bashrc
cd ..
mkdir data
cd data
wget http://files.fast.ai/data/dogscats.zip
unzip -q dogscats.zip
cd ../fastai/courses/dl1/
ln -s ~/data ./
jupyter notebook --generate-config
