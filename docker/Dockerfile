# Planemo and RStudio with vignette-building capability (via R package 'devtools')
# Step 1 - Build from this Dockerfile (you must cd to the directory containing it first)
#               docker build -t eschen42/devplan .
# Step 2 - Create a home directory, e.g.:
#               mkdir ~/devplanbrew
# Step 3 - Run the container with this new directory; note that the container will create
#          files in this directory with UID 1000 (which is user rstudio on the guest), e.g.:
#               docker run --name devplan --rm -ti -p 8787:8787 -p 8790:9090 -v ~/devplanbrew:/home/rstudio eschen42/devplanbrew
# Step 4 - On the host, browse to RStudio at http://localhost:8787
# Step 5 - Set up /home/rstudio/.ssh (on the guest; ~/devplan/.ssh on the host) if desired
#          and make sure that the permissions are right (see: https://superuser.com/a/215506)
# Step 6 - On the guest:
#          - Set up access to git
#          - Set up LinuxBrew per http://linuxbrew.sh/
#          - Set up planemo in LinuxBrew per http://planemo.readthedocs.io/en/latest/readme.html#obtaining-planemo
#               brew tap galaxyproject/tap
#               brew install gnu-sed
#               brew install util-linux
#               brew install gnutls
#               brew install planemo
#          - Clone the wrapper project you want to work with and cd to it.
#          - Run the following:
#               planemo conda_init
#               planemo conda_install .
#               planemo test --conda_dependency_resolution .
#          - Once tests are passing, run the following:
#               planemo serve --host 0.0.0.0 --conda_dependency_resolution .
# Step 7 - On the host, browse to the test instance at http://localhost:8790

FROM rocker/verse:3.4.1
MAINTAINER Arthur C. Eschenlauer, esch0041@umn.edu
RUN /bin/sh -c 'apt-get update'   && \
    /bin/sh -c 'apt-get install -y texlive-science texlive-latex-extra'
RUN apt-get -y install bzip2 curl wget vim-tiny 
RUN update-alternatives --install /usr/bin/vim vim /usr/bin/vim.tiny 10
RUN apt-get -y install net-tools bind9-host dnsutils
RUN apt-get -y install locales gawk debconf git
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8
RUN sed -i -e '/rstudio:$/ s/:$/:\/bin\/bash/' /etc/passwd

#optional - install man pages
RUN apt-get -y install man-db manpages manpages-dev

RUN apt-get -y install procps
RUN apt-get -y install openssh-client

RUN echo "su - rstudio" >> /init

# need this for planemo under brew
RUN apt-get -y install build-essential
RUN apt-get -y install libgnutls-openssl27
RUN apt-get -y install libgnutls28-dev

# for planemo under pip
RUN apt-get -y install virtualenv
