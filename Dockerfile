FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04

RUN apt update
RUN apt install -y curl git unzip graphviz wget

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

RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py

RUN pip install ipywidgets
RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix
RUN echo
RUN echo ---
RUN echo - YOU NEED TO REBOOT YOUR PAPERSPACE COMPUTER NOW
RUN echo ---

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