delete_blobs()
{
	BLOB_LIST="$(az storage blob list \
		--account-name "$AZURE_ACCOUNT_NAME" \
		--account-key "$AZURE_ACCOUNT_KEY" \
		--container-name "$CONTAINER" \
		| jq -j '.[] | .name, "\t", .properties.lastModified, "\n"'
	)"

	DELETE_DATE="$(date --date="$DAYS days ago" +%s)"

	while IFS=$'\t' read -r FILENAME DATE_MODIFIED; do
		FILE_DATE="$(date --date="$DATE_MODIFIED" +%s)"

		if [ "$FILE_DATE" -le "$DELETE_DATE" ]; then
			echo "Deleting '$FILENAME'..!"
			az storage blob delete \
				--account-name "$AZURE_ACCOUNT_NAME" \
				--account-key "$AZURE_ACCOUNT_KEY" \
				--container-name "$CONTAINER" \
				--delete-snapshots include \
				--name "$FILENAME"
		fi
	done <<< "$BLOB_LIST"
}
