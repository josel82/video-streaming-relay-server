# Base Image Alpine Linux
FROM alpine:3.24.1

# Enable the community repository and install bash + srt utilities
RUN echo "@community https://dl-cdn.alpinelinux.org/alpine/v3.24/community" >> /etc/apk/repositories \
    && apk add --no-cache bash libsrt-progs@community
# Specify the working directory
WORKDIR /usr/src/app

# Copying the script to the image
COPY scripts/srt-relay.sh .
# Ensuring the script has executable permissions
RUN chmod +x srt-relay.sh
# Run the script when starting the container
ENTRYPOINT [ "./srt-relay.sh" ]
# Set default parameters Input Port: 10001 - Output Port: 10002 - Latency 250ms
CMD [ "10001", "10002", "250" ]




