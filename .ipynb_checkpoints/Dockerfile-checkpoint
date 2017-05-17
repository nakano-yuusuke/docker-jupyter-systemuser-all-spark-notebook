FROM jupyter/all-spark-notebook

USER root

# fetch juptyerhub-singleuser entrypoint
ADD https://raw.githubusercontent.com/jupyter/jupyterhub/master/scripts/jupyterhub-singleuser /usr/local/bin/jupyterhub-singleuser
RUN chmod 755 /usr/local/bin/jupyterhub-singleuser

RUN sed -ri 's!/usr/local!/opt/conda/bin:/usr/local!' /etc/sudoers

ADD https://raw.githubusercontent.com/jupyterhub/dockerspawner/master/systemuser/systemuser.sh /srv/singleuser/systemuser.sh
CMD ["sh", "/srv/singleuser/systemuser.sh"]

RUN apt-get update && apt-get install -y \
        supervisor
RUN conda update --all
RUN conda install libpng freetype numpy pip scipy
RUN conda install ipykernel jupyter matplotlib conda-build && \
	python -m ipykernel.kernelspec

# Install TensorFlow CPU version.
RUN pip install --upgrade -I setuptools
ENV TENSORFLOW_VERSION 0.10.0
RUN curl -L -O https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-${TENSORFLOW_VERSION}-cp35-cp35m-linux_x86_64.whl
RUN pip --no-cache-dir install --upgrade \
	tensorflow-${TENSORFLOW_VERSION}-cp35-cp35m-linux_x86_64.whl
# Install Chainer (without GPU)
RUN pip install --install-option="--cupy-no-cuda" chainer
# Mecab
RUN apt-get install -y --no-install-recommends \
	mecab libmecab-dev mecab-ipadic-utf8
RUN conda skeleton pypi mecab-python3 && conda build mecab-python3
# gensim
RUN conda install gensim
# skflow
RUN pip install git+git://github.com/google/skflow.git
# Octave
RUN apt-get install -y --no-install-recommends default-jre-headless octave
# Octave kernel
RUN pip install octave_kernel
RUN python -m octave_kernel.install
# pyquery
RUN conda install libxml2 libxslt lxml gcc
RUN pip install pyquery
#RUN conda skeleton pypi pyquery && conda build pyquery
# SQL
RUN conda install pymysql
RUN conda install psycopg2
RUN conda install ipython-sql
# pyhive
RUN pip install pyhive
# plotly
RUN pip install plotly
RUN pip install cufflinks
# spark2
ENV APACHE_SPARK_VERSION 2.0.0
RUN cd /tmp && \
        wget -q http://d3kbcqa49mib13.cloudfront.net/spark-${APACHE_SPARK_VERSION}-bin-hadoop2.7.tgz && \
        tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop2.7.tgz -C /usr/local && \
        rm spark-${APACHE_SPARK_VERSION}-bin-hadoop2.7.tgz
RUN cd /usr/local && rm -f spark && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop2.7 spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.1-src.zip
# for NT lab
RUN conda install zc.lockfile linecache2 && pip install argparse
# clean
RUN apt-get -y autoremove && apt-get clean # && rm -rf /var/lib/apt/lists/*
# fix
RUN chmod a+r /opt/conda/lib/python3.5/site-packages/prettytable-0.7.2-py3.5.egg-info/PKG-INFO
# smoke test entrypoint
RUN USER_ID=65000 USER=systemusertest sh /srv/singleuser/systemuser.sh -h && userdel systemusertest

