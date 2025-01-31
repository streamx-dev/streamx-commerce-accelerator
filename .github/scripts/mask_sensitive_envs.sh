key_value_pairs="$1"

while IFS= read -r line; do
  sensitive_value=$(echo "$line" | cut -d'=' -f2-)
  # Mask the sensitive value in GitHub Actions
  echo "::add-mask::$sensitive_value"
done <<< "$key_value_pairs"