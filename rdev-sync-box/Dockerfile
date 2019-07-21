FROM ubuntu:bionic

RUN apt-get update
RUN apt-get install -y lsb-release curl gnupg apt-transport-https ca-certificates
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update
RUN apt-get install -y google-cloud-sdk
RUN gcloud config set pass_credentials_to_gsutil false
ADD sync.sh /opt/sync.sh
ADD .boto /root/.boto

VOLUME /src
VOLUME /creds

ARG project_id
ARG bucket_name

RUN gcloud config set project ${project_id}
ENV BUCKET_NAME=$bucket_name

ENTRYPOINT [ "bash", "/opt/sync.sh" ]