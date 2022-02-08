#!/usr/bin/env bash

NC_CONFIG=/config.json
if [ ! -z "${HTTP_PORT}" ] ; then HTTP_PORT=8080; fi

IPADDR=$(hostname -i)
HOSTNAME=$(hostname)

function get_response_code {
  case ${1} in
    "200") echo "200 OK" ;;
    "400") echo "400 Bad Request" ;;
    "401") echo "401 Unauthorized" ;;
    "403") echo "403 Forbidden" ;;
    "500") echo "500 Internal Server Error" ;;
    *) echo "200 OK" ;;
  esac
}

while true ; do

  RESPONSE_CODE=$(cat ${NC_CONFIG} | jq -r '.response_code')
  RESPONSE_MSG=$(cat ${NC_CONFIG} | jq -r '.response_msg')

  if [ -z "${RESPONSE_CODE}" ] ; then RESPONSE_CODE=200; fi
  if [ -z "${RESPONSE_MSG}" ] ; then RESPONSE_MSG="Hello Grasshopper!"; fi

  MSG="{\"response_code\":${RESPONSE_CODE},\"response_msg\":\"${RESPONSE_MSG}\",\"ip_address\":\"${IPADDR}\",\"hostname\":\"${HOSTNAME}\"}"
  echo -ne "HTTP/1.1 $(get_response_code ${RESPONSE_CODE})\n\n$(echo ${MSG} | jq .)" | nc -q 0 -l ${HTTP_PORT}

done
