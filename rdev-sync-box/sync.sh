#!/bin/bash

gsutil ls gs://$BUCKET_NAME > /dev/null
if [ $? -ne 0 ]; then
    gsutil mb gs://$BUCKET_NAME
fi

while true; do
    gsutil -m rsync -x '^\.vagrant$' -d -J /home/rdev/src gs://$BUCKET_NAME
    sleep 5
done