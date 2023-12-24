#!/bin/bash

echo "my_metric 42" | curl -u admin:kmaAt16i@  --data-binary @- http://18.143.148.174:9091/metrics/job/pushgateway
