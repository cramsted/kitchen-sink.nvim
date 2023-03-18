FROM ubuntu:20.04

RUN apt update -y
RUN apt install git -y

# TODO: use .env file in the build stage to create the user dir
#   use it also for the run stage to setup the user
#   if running in test mode, have it take care of generating the .env file
#     Make sure to add .env file to .gitignore!!
RUN useradd -ms /bin/bash cramstedt

RUN mkdir -p /app
WORKDIR /app

CMD ["/startup.sh"]
