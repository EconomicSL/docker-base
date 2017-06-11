# use the official java 8 (OpenJDK) as our base image
FROM java:8

MAINTAINER davidrpugh <david.pugh@maths.ox.ac.uk>

RUN apt-get update -y && \
    apt-get install -y bzip2 wget && \
    apt-get clean

# Run docker image with non-root user as security precaution
RUN useradd --create-home --shell /bin/bash main

USER main
ENV HOME /home/main
ENV SHELL /bin/bash
ENV USER main
WORKDIR $HOME

USER root
RUN chown -R main:main /home/main

# Install minconda3 package manager...
USER main
RUN echo "Downloading Miniconda..." && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    $SHELL Miniconda3-latest-Linux-x86_64.sh -b && \
    rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH $HOME/miniconda3/bin:$PATH

# Install various Python dependencies...
RUN conda install --yes jupyter
RUN conda install --yes numpy pandas scipy matplotlib seaborn bokeh
RUN conda clean --yes --tarballs

ENV SCALA_VERSION 2.12.2
ENV SBT_VERSION 0.13.15

USER root
# Scala expects this file
RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

USER main

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

EXPOSE 8888

ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0"]
