#!/bin/bash
# SRT Relay Script
# This script starts the SRT relay service

INPUT_PORT="$1"
OUTPUT_PORT="$2"
LATENCY="$3"

# Log file location
LOG_FILE="/var/log/srt-relay.log"

# Function to log messages with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Start the relay
log_message "Starting SRT relay service"
log_message "Listening on ports: $INPUT_PORT (input) and $OUTPUT_PORT (output)"
log_message "Latency: ${LATENCY}ms"

# Execute the relay command
exec srt-live-transmit \
    "srt://:${INPUT_PORT}?mode=listener&latency=${LATENCY}" \
    "srt://:${OUTPUT_PORT}?mode=listener&latency=${LATENCY}" \
    -v