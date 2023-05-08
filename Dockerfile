FROM ubuntu:20.04

RUN apt update -y
RUN apt install git -y

# TODO: use .env file in the build stage to create the user dir
#   use it also for the run stage to setup the user
#   if running in test mode, have it take care of generating the .env file
#     Make sure to add .env file to .gitignore!!
ARG USER
RUN echo "testing: " $USER
RUN useradd -ms /bin/bash $USER

RUN mkdir -p /app
WORKDIR /app

CMD ["/startup.sh"]

##############################

FROM fedora:27

RUN yum update -y
RUN yum install git bison cmake -y
RUN dnf groupinstall -y "Development Tools" "Development Libraries"

# TODO: use .env file in the build stage to create the user dir
#   use it also for the run stage to setup the user
#   if running in test mode, have it take care of generating the .env file
#     Make sure to add .env file to .gitignore!!
ARG USER
RUN echo "testing: " $USER
RUN useradd -ms /bin/bash $USER

RUN mkdir -p /app
WORKDIR /app

CMD ["/startup.sh"]
