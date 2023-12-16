#!/bin/bash

echo "my_metric 42" | curl -u admin:kmaAt16i@  --data-binary @- http://13.250.191.64:9091/metrics/job/pushgateway
