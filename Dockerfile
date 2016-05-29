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
RUN pip install --upgrade pip

# Install TensorFlow CPU version.
ENV TENSORFLOW_VERSION 0.8.0
RUN curl https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-${TENSORFLOW_VERSION}-cp34-cp34m-linux_x86_64.whl -o tensorflow-${TENSORFLOW_VERSION}-cp35-cp35m-linux_x86_64.whl
RUN pip --no-cache-dir install --upgrade \
	tensorflow-${TENSORFLOW_VERSION}-cp35-cp35m-linux_x86_64.whl
# Mecab
RUN apt-get install -y --no-install-recommends \
	mecab libmecab-dev mecab-ipadic-utf8
RUN conda skeleton pypi mecab-python3 && conda build mecab-python3
# gensim
RUN conda install gensim
# skflow
RUN pip install git+git://github.com/google/skflow.git
# Octave
RUN apt-get install -y --no-install-recommends octave
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
RUN pip install ipython-sql
# pyhive
RUN pip install pyhive
# clean
RUN apt-get -y autoremove && apt-get clean # && rm -rf /var/lib/apt/lists/*
# smoke test entrypoint
RUN USER_ID=65000 USER=systemusertest sh /srv/singleuser/systemuser.sh -h && userdel systemusertest

