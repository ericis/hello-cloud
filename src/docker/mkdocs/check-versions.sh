#!/bin/bash

set -eu

get_docker_hub_most_recent_image_tag_not_latest() {
  local docker_namespace=$1
  local docker_repository=$2
  local url="https://hub.docker.com/v2/repositories/${docker_namespace}/${docker_repository}/tags"

  echo "GET $url"

  local docker_tag_latest_version=$( \
    curl -s $url \
    | jq -r '[.results[] | select(.name != "latest")] | sort_by(.last_updated)[-1] | .name' \
    | cat \
  )

  echo $docker_tag_latest_version
}

get_dockerfile_arg_value() {
  local dockerfile_path=$1
  local variable_name=$2
  local variable_token="ARG ${variable_name}="

  # sed: replace arg name
  # sed: replace double quotes
  local variable_value=$(
    grep \
      "$variable_token" \
      "$dockerfile_path" \
      | sed 's/.*=//' \
      | sed 's/"//g' \
    )

  echo $variable_value
}

test_mkdocs_docker() {

  echo ''
  echo 'Testing MkDocs docker image version...'

  local docker_namespace="squidfunk"
  local docker_repository="mkdocs-material"

  local docker_latest_version=$(
    get_docker_hub_most_recent_image_tag_not_latest \
      $docker_namespace \
      $docker_repository \
  )

  echo "${docker_latest_version} ... latest tag version on docker hub."

  local dockerfile_path='./Dockerfile'
  local dockerfile_variable_name='MKDOCS_MATERIAL_VERSION'

  local dockerfile_docker_mkdocs_material_version=$(
    get_dockerfile_arg_value \
      $dockerfile_path \
      $dockerfile_variable_name \
  )

  echo "${dockerfile_docker_mkdocs_material_version} ... Dockerfile version."

  echo "source: $dockerfile_path"
}

test_mkdocs_docker
