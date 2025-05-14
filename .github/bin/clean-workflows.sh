#!/bin/bash

for run in $(gh run list --json databaseId --jq '.[].databaseId'); do
    gh run delete "$run";
done