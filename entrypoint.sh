#!/bin/sh

./coduoserver start

# Run the expect script in the background
./console_expect.exp &

# Get the expect script process PID
expect_pid=$!

# Wait for the expect script process to complete
wait $expect_pid
