CONTAINERS=$(az storage container list \
	--account-name "$AZURE_ACCOUNT_NAME" \
	--account-key "$AZURE_ACCOUNT_KEY" \
	--query '[].name' \
	-o tsv \
)

while read -r CONTAINER; do
	SUFFIX="$(grep -oP -- '-\K(nodelete|\d{1,2})$' <<< "$CONTAINER")"

	if [ "$SUFFIX" == '' ]; then
		DAYS="90"
	elif [ "$SUFFIX" == 'nodelete' ]; then
		echo "The container '$CONTAINER' has the 'nodelete' suffix, skipping..!"
		continue
	else
		DAYS="$SUFFIX"
	fi

	[ "$DAYS" -eq 1 ] && ONE_SUFFIX='' || ONE_SUFFIX='s'

	DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ" --date="$DAYS days ago")"

	echo "Deleting all blobs older than $DAYS day$ONE_SUFFIX in container '$CONTAINER'..."

	az storage blob delete-batch \
		--account-name "$AZURE_ACCOUNT_NAME" \
		--account-key "$AZURE_ACCOUNT_KEY" \
		--source "$CONTAINER" \
		--if-unmodified-since "$DATE"

	echo
done <<< "$CONTAINERS"
