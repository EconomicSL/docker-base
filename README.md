# Economic SL - Base Dockerfile
This repo defines a Dockerfile to create an environment for using the [economic simulation library](https://github.com/EconomicSL).

### How do I run it?

Firstly, you will need to have docker installed, see the [getting started documentation](https://docs.docker.com/get-started/) for help.

You need to build the image `docker build . -t esl/base`.

Then run the container `docker run -p 8888:8888 esl/base`

This starts a [Jupyter Notebook](http://jupyter.org/) on port 8888. You will need to copy the URL (which includes an access token) from the command line output.

#### Linux

You can access the notebook at `localhost:8888`

#### Mac OS & Windows

If you are using docker-machine you need to find out the `DOCKER_HOST` ip address by running `docker env [your machine name]`

Which lets you access the notebook (for example) at `192.168.99.100:8888`.
