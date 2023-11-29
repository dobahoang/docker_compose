#!/bin/bash

echo "my_metric 42" | curl -u admin:kmaAt16i@ --data-binary @- http://pushgateway:9091/metrics/job/pushgateway
