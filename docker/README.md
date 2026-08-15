# SRT Relay Container

This repository provides a lightweight Alpine Linux-based Docker container designed to relay SRT (Secure Reliable Transport) streams.

## How to Run
### Basic Usage
To run the container with the default settings (Input Port: 10001, Output Port: 10002, Latency: 250ms):

```Bash

docker run --network=host srt-relay:latest

```
### Custom Configuration
You can override the default ports and latency by providing three arguments to the container command.

**Important:** You must provide all three arguments (Input Port, Output Port, and Latency) in the correct order, or the container will fail to start.


```Bash
docker run --network=host srt-relay:latest <INPUT_PORT> <OUTPUT_PORT> <LATENCY_MS>
```

Example:
To listen on port 5000 for input, relay to port 5001 for output, with a latency of 100ms:

```Bash
docker run --network=host srt-relay:latest 5000 5001 100
```

## Prerequisites

- **Network Mode:** The container uses --network=host to ensure the SRT ports are accessible on the host machine's network interface.
- **Arguments:** The script expects exactly three arguments:
- **INPUT_PORT:** The port to listen on for the incoming stream.
- **OUTPUT_PORT:** The port to broadcast the relay stream.
- **LATENCY_MS:** The SRT latency configuration in milliseconds.