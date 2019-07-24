#!/bin/bash
set -e
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
COMPOSE_FILE="${BASE_DIR}/docker-compose.yaml"
TF_DIR="${BASE_DIR}/rdev-remote-box"

PROJECT_ID=
BUCKET_NAME=
CREDS_FILE=
USER_NAME="$USER"
ACTION=up

function usage() {
    echo "boxit.sh -p <project id> -b <bucket name> -c <path to creds file> -u <user name> -a <action:up|down>"
    exit 1
}

while getopts “:p:b:c:u:a:” opt; do
  case $opt in
    p) PROJECT_ID=$OPTARG ;;
    b) BUCKET_NAME=$OPTARG ;;
    c) CREDS_FILE=$OPTARG ;;
    u) USER_NAME=$OPTARG ;;
    a) ACTION=$OPTARG ;;
  esac
done

if [ -z "${PROJECT_ID}" ]; then
    echo "Project Id Required"
    usage
fi
if [ -z "${BUCKET_NAME}" ]; then
    echo "Bucket Name Required"
    usage
fi
if [ -z "${CREDS_FILE}" ]; then
    echo "Credentials File Required"
    usage
fi

export PROJECT_ID="${PROJECT_ID}"
export BUCKET_NAME="${BUCKET_NAME}"
export CREDS_FILE="${CREDS_FILE}"
export USER_NAME="${USER_NAME}"

if [ 'up' == "${ACTION}" ]; then
    terraform init ${TF_DIR}
    terraform apply -state ${TF_DIR}/${BUCKET_NAME}.tfstate -auto-approve -var "creds_file=${CREDS_FILE}" -var "project_id=${PROJECT_ID}" -var "bucket_name=${BUCKET_NAME}" -var "user_name=${USER_NAME}" ${TF_DIR}
    docker-compose -f ${COMPOSE_FILE} up --build -d
elif [ 'down' == "${ACTION}" ]; then
    docker-compose -f ${COMPOSE_FILE} down
    terraform destroy -state ${TF_DIR}/${BUCKET_NAME}.tfstate -auto-approve -var "creds_file=${CREDS_FILE}" -var "project_id=${PROJECT_ID}" -var "bucket_name=${BUCKET_NAME}" -var "user_name=${USER_NAME}" ${TF_DIR}
else
    echo "Action is not one of the allowed values"
    usage
fi