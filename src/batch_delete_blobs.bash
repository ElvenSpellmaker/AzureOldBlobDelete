delete_blobs()
{
	DELETE_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ" --date="$DAYS days ago")"

	az storage blob delete-batch \
		--account-name "$AZURE_ACCOUNT_NAME" \
		--account-key "$AZURE_ACCOUNT_KEY" \
		--source "$CONTAINER" \
		--if-unmodified-since "$DELETE_DATE" \
		--delete-snapshots include
}
