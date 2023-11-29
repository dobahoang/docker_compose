#!/bin/bash

echo "my_metric 42" | curl --data-binary @- http://pushgateway:9091/metrics/job/pushgateway
