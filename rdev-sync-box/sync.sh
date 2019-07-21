#!/bin/bash

while true; do
    gsutil rsync -d -J /src gs://$BUCKET_NAME
    sleep 5
done