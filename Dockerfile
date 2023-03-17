FROM ubuntu:20.04

RUN useradd -ms /bin/bash cramsted
USER cramsted

COPY /tmp/kitchen-sink /home/cramsted
WORKDIR /home/cramsted


CMD ["sleep", "100000000"]
