FROM ubuntu:20.04

RUN apt install git

# TODO: use .env file in the build stage to create the user dir
#   use it also for the run stage to setup the user
#   if running in test mode, have it take care of generating the .env file
#     Make sure to add .env file to .gitignore!!
RUN useradd -ms /bin/bash cramstedt
# USER testuser

# COPY /tmp/kitchen-sink /home/testuser
# RUN mkdir -p /home/testuser/kitchen-sink
RUN mkdir -p /app
WORKDIR /app

# TODO: add in script that will run the install script initially before sleeping
#   have it create the .config and .local directories before running the script, otherwise the symlinks won't be made
CMD ["sleep", "100000000"]
