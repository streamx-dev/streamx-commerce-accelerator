#!/bin/bash
REF_NAME=$1
if [ "$REF_NAME" = "main" ] || [ "$REF_NAME" = "" ]
then
  echo "default"
else
  echo "${REF_NAME//[^a-zA-Z0-9]/-}"
fi
