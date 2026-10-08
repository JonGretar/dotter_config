aws-creds() {
    if (( $# != 1 )); then
        echo "Usage: aws-creds <profile>" >&2
        return 1
    fi

    local profile="$1" login_profile="${1}-login" credentials
    credentials=$(aws configure export-credentials --profile "$login_profile" --format env) || {
        echo "Run: aws login --profile $login_profile" >&2
        return 1
    }
    eval "$credentials"
    aws configure set aws_access_key_id     "$AWS_ACCESS_KEY_ID"     --profile "$profile"
    aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile "$profile"
    aws configure set aws_session_token     "$AWS_SESSION_TOKEN"     --profile "$profile"

    echo "$profile credentials valid until $AWS_CREDENTIAL_EXPIRATION"
    unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_CREDENTIAL_EXPIRATION
}
