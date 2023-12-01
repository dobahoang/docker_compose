#!/bin/bash

echo "my_metric 42" | curl -u admin:kmaAt16i@  --data-binary @- http://13.212.245.118:9091/metrics/job/pushgateway
