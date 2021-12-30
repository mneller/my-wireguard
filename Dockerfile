# Modified version from https://github.com/cmulk/wireguard-docker/blob/main/Dockerfile.alpine
FROM alpine:latest

RUN apk update && apk --no-cache add wireguard-tools iptables ip6tables inotify-tools bind-tools iputils

# Copy the configuration files
# Will be overloaded later by a dynamic volume mount
COPY ./etc/wireguard/privatekey /etc/wireguard/privatekey
COPY ./etc/wireguard/wg0.conf /etc/wireguard/wg0.conf
# Set the run script
COPY ./scripts/run.sh /scripts/run.sh
RUN chmod 755 /scripts/*
ENV PATH="/scripts:${PATH}"

# Use iptables masquerade NAT rule
ENV IPTABLES_MASQ=1

# Watch for changes to interface conf files (default off)
ENV WATCH_CHANGES=0


# Start the service:
CMD run.sh
EXPOSE 5555/udp