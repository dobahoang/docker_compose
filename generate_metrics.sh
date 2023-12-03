#!/bin/bash

echo "my_metric 42" | curl -u admin:kmaAt16i@  --data-binary @- http://54.254.132.56:9091/metrics/job/pushgateway
