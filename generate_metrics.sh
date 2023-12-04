#!/bin/bash

echo "my_metric 42" | curl -u admin:kmaAt16i@  --data-binary @- http://54.169.111.153:9091/metrics/job/pushgateway
