#!/bin/bash

echo "my_metric 42" | curl --data-binary @- http://54.254.45.53:9091/metrics/job/pushgateway
