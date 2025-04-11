#!/bin/bash

set -e

PLUGIN_README="${PLUGIN_README:-README.md}"

if [[ -z "$PLUGIN_USERNAME" ]]; then
    printf "Docker Hub username not set.\n"
    exit 1
elif [[ -z "$PLUGIN_PASSWORD" ]]; then
    printf "Docker Hub password not set.\n"
    exit 1
elif [[ -z "$PLUGIN_REPO" ]]; then
    printf "Docker Hub repository not set.\n"
    exit 1
fi

TOKEN=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    -d '{"username": "'"$PLUGIN_USERNAME"'", "password": "'"$PLUGIN_PASSWORD"'"}' \
    https://hub.docker.com/v2/users/login/ | jq -r .token)

if [[ "$TOKEN" = "null" ]]; then
    printf "Unable to login to Docker Hub.\n"
    exit 1
fi

if [[ -n "$PLUGIN_DESCRIPTION" ]]; then
    CODE=$(jq -n --arg data "$PLUGIN_DESCRIPTION" '{"registry":"registry-1.docker.io","description": $data }' | \
        curl -s -o /dev/null -L -w "%{http_code}" https://hub.docker.com/v2/repositories/"$PLUGIN_REPO"/ \
            -d @- -X PATCH \
            -H "Content-Type: application/json" \
            -H "Authorization: JWT $TOKEN")

    if [[ "$CODE" = "200" ]]; then
        printf "Successfully pushed description to Docker Hub.\n"
    else
        printf "Unable to push description to Docker Hub, response code: %s\n" "$CODE"
        exit 1
    fi
fi

if [[ -r "$PLUGIN_README" ]]; then
    DATA="$(<"$PLUGIN_README")"
    CODE=$(jq -n --arg data "$DATA" '{"registry":"registry-1.docker.io","full_description": $data }' | \
        curl -s -o /dev/null -L -w "%{http_code}" https://hub.docker.com/v2/repositories/"$PLUGIN_REPO"/ \
            -d @- -X PATCH \
            -H "Content-Type: application/json" \
            -H "Authorization: JWT $TOKEN")

    if [[ "$CODE" = "200" ]]; then
        printf "Successfully pushed README to Docker Hub.\n"
    else
        printf "Unable to push README to Docker Hub, response code: %s\n" "$CODE"
        exit 1
    fi
fi
