if [ -z "$QUARKUS_PROFILE" ]; then
  echo "QUARKUS_PROFILE env variable is required." >&2
  exit 1;
else
  quarkus_profile_prefix="_${QUARKUS_PROFILE}_"
fi

web_url_env_var_name="${quarkus_profile_prefix}WEB_URL"
echo "${!web_url_env_var_name}"