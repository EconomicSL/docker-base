# use the official java 8 (OpenJDK) as our base image
FROM java:8

MAINTAINER davidrpugh <david.pugh@maths.ox.ac.uk>

RUN apt-get update -y && \
    apt-get install -y wget bzip2

# Run docker image with non-root user as security precaution
RUN useradd --create-home --shell /bin/bash main

USER main
ENV HOME /home/main
ENV SHELL /bin/bash
ENV USER main
WORKDIR $HOME

USER root
RUN chown -R main:main /home/main


# Install minconda3
USER main
RUN echo "Downloading Miniconda..." && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    $SHELL Miniconda3-latest-Linux-x86_64.sh -b && \
    rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH $HOME/anaconda/bin:$PATH
