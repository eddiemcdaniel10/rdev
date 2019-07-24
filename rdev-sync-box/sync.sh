#!/bin/bash

while true; do
    gsutil -m rsync -x '^\.vagrant$' -d -r -J /home/rdev/src gs://$BUCKET_NAME
    sleep 5
done