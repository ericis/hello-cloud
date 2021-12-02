#!/bin/sh

set -eu

# contains(string, substring)
#
# Returns 0 if the specified string contains the specified substring,
# otherwise returns 1.
contains() {
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"
    then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

if ! command -v aws >/dev/null 2>&1; then
    echo "The AWS CLI ('aws') could not be found and must be installed." 1>&2
    exit 1
fi

if ! command -v eb >/dev/null 2>&1; then
    echo "The Elastic Beanstalk CLI ('eb') could not be found and must be installed." 1>&2
    exit 1
fi

if [ -z "$AWS_ENV_NAME" ]; then
    echo "The environment variable AWS_ENV_NAME is required." 1>&2
    exit 1
fi

if [ -z "$AWS_APP_NAME" ]; then
    echo "The environment variable AWS_APP_NAME is required." 1>&2
    exit 1
fi

if [ -z "$AWS_PLATFORM" ]; then
    echo "The environment variable AWS_PLATFORM is required." 1>&2
    exit 1
fi

if [ -z "$AWS_REGION" ]; then
    echo "The environment variable AWS_REGION is required." 1>&2
    exit 1
fi

aws_env_name="$AWS_ENV_NAME"
aws_app_name="$AWS_APP_NAME"
aws_app_port="${AWS_APP_PORT:-5000}"
aws_app_tags="${AWS_APP_TAGS:-organization=ourchitecture,project=hello-cloud}"
aws_region="$AWS_REGION"
aws_platform="$AWS_PLATFORM"

# env_exists_output=$(eb status "$aws_env_name" --region "$aws_region" || true)
env_exists_output=$(aws elasticbeanstalk describe-environments \
  --application-name "$aws_app_name" \
  --no-include-deleted \
  --output json \
  --no-cli-pager \
  --no-cli-auto-prompt)

if ! contains "$env_exists_output" "$aws_env_name"; then
  echo 'Creating Elastic Beanstalk environment and application...'

  eb init "$aws_app_name" \
    --platform "$aws_platform" \
    --region "$aws_region" \
    --tags "$aws_app_tags"

  eb create \
    --sample "$aws_env_name"

  eb setenv SERVER_PORT="$aws_app_port"

  echo 'Successfully created application.'
else
  echo 'The AWS Elastic Beanstalk environment and application already exists.'
fi
