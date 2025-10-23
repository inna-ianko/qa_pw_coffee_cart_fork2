#!/bin/bash

# Fetch the artifact ID using curl and jq (instead of Python)
REPORT_ID=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/inna-ianko/qa_pw_coffee_cart_fork2/actions/artifacts?name=github-pages" \
  | jq -r '.artifacts[0].id')

# Check if the REPORT_ID is retrieved
if [[ -z "$REPORT_ID" ]]; then
  echo "Artifact ID not found!"
  exit 1
fi

# Download the artifact using the REPORT_ID
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${{ secrets.TOKEN }}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/inna-ianko/qa_pw_coffee_cart_fork2/actions/artifacts/$REPORT_ID/zip" \
  -o pages.zip

mkdir old_pages allure_history && unzip pages.zip -d old_pages && tar -xvf old_pages/artifact.tar -C allure_history  
