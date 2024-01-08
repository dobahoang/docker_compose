#!/bin/bash

echo "my_metric 42" | curl -u admin:kmaAt16i@  --data-binary @- http://13.214.202.206:9091/metrics/job/pushgateway
