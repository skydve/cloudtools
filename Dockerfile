FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04
# FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04

RUN apt update
RUN apt install -y curl git unzip docker.io graphviz cmake
RUN usermod -a -G docker $USER

# RUN pip3 install --upgrade pip3
# RUN pip3 install --upgrade numpy scipy matplotlib scikit-learn pandas seaborn plotly statsmodels
# RUN pip3 install --upgrade nose tqdm pydot watermark geopy joblib

RUN wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
RUN bash Anaconda3-5.0.1-Linux-x86_64.sh -b
RUN cd
RUN git clone https://github.com/fastai/fastai.git
RUN cd fastai/

RUN echo 'export PATH=~/anaconda3/bin:$PATH' >> ~/.bashrc
RUN export PATH=~/anaconda3/bin:$PATH
RUN source ~/.bashrc
RUN conda env update

RUN echo 'source activate fastai' >> ~/.bashrc
RUN source activate fastai
RUN source ~/.bashrc
RUN cd ..

RUN mkdir data
RUN cd data
RUN wget http://files.fast.ai/data/dogscats.zip
RUN unzip -q dogscats.zip
RUN cd ../fastai/courses/dl1/
RUN ln -s ~/data ./

# RUN apt -y install libboost-program-options-dev zlib1g-dev libboost-python-dev

# RUN apt -y install openjdk-8-jdk
# ENV CPLUS_INCLUDE_PATH=/usr/lib/jvm/java-8-openjdk-amd64/include/linux:/usr/lib/jvm/java-1.8.0-openjdk-amd64/include

# Vowpal Wabbit
# RUN git clone git://github.com/JohnLangford/vowpal_wabbit.git && \
#     cd vowpal_wabbit && make && make install
# # python wrapper
# RUN cd vowpal_wabbit/python && python3 setup.py install
# RUN pip3 install --upgrade vowpalwabbit

# # XGBoost
# RUN git clone --recursive https://github.com/dmlc/xgboost && \
#     cd xgboost && \
#     make -j4 

# xgboost python wrapper
# RUN cd xgboost/python-package; python3 setup.py install && cd ../..

# RUN apt-get -y install cmake 

# LightGBM
# RUN cd /usr/local/src && git clone --recursive --depth 1 https://github.com/Microsoft/LightGBM && \
    # cd LightGBM && mkdir build && cd build && cmake .. && make -j $(nproc) 

# LightGBM python wrapper
# RUN cd /usr/local/src/LightGBM/python-package && python3 setup.py install 

# # TensorFlow 
# RUN pip3 install --upgrade tensorflow  

# # Keras with TensorFlow backend
# RUN pip3 install --upgrade keras

# RUN jupyter notebook --allow-root --generate-config -y
# RUN echo "c.NotebookApp.password = ''" >> ~/.jupyter/jupyter_notebook_config.py
# RUN echo "c.NotebookApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py
# RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

# Facebook Prophet
# RUN pip3 install --upgrade pystan cython
# RUN pip3 install --upgrade fbprophet
# RUN pip3 install ipywidgets
# RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix


COPY docker_files/entry-point.sh /
# COPY docker_files/h2o /usr/local/bin/

RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py


# Final setup: directories, permissions, ssh login, symlinks, etc
RUN mkdir -p /home/user && \
    mkdir -p /var/run/sshd && \
    echo 'root:12345' | chpasswd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
  #  chmod a+x /usr/local/bin/h2o && \
    chmod a+x /entry-point.sh

WORKDIR /home/user
EXPOSE 22 4545

ENTRYPOINT ["/entry-point.sh"]
CMD ["shell"]