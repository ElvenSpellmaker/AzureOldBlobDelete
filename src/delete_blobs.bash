CONTAINERS=$(az storage container list \
	--account-name "$AZURE_ACCOUNT_NAME" \
	--account-key "$AZURE_ACCOUNT_KEY" \
	--query '[].name' \
	-o tsv \
)

# Can't resolve this statically...
# shellcheck source=/dev/null
source "$SOURCE_DIR/${DELETE_TYPE}_delete_blobs.bash"

while read -r CONTAINER; do
	SUFFIX="$(grep -oP -- '-\K(nodelete|\d{1,2})$' <<< "$CONTAINER")"

	if [ "$SUFFIX" == '' ]; then
		DAYS="$DEFAULT_DAYS"
	elif [ "$SUFFIX" == 'nodelete' ]; then
		echo "The container '$CONTAINER' has the 'nodelete' suffix, skipping..!"
		continue
	else
		DAYS="$SUFFIX"
	fi

	[ "$DAYS" -eq 1 ] && ONE_SUFFIX='' || ONE_SUFFIX='s'

	echo "Deleting all blobs older than $DAYS day$ONE_SUFFIX in container '$CONTAINER'..."

	delete_blobs

	echo
done <<< "$CONTAINERS"
