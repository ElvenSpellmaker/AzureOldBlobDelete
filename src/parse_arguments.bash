if [ $# -eq 0 ] || [ "$1" == "--help" ]; then
	echo "$(<"$BASE_DIR/help_message")"
	exit
fi

while getopts ":a: :k: :d: :t:" option
do
	# shellcheck disable=SC2034
	case "${option}"
	in
		a) AZURE_ACCOUNT_NAME=${OPTARG};;
		k) AZURE_ACCOUNT_KEY=${OPTARG};;
		d) DEFAULT_DAYS=${OPTARG};;
		t) DELETE_TYPE=${OPTARG};;
		?) echo "Error: Invalid option was specified: ${OPTARG}";;
	esac
done

# shellcheck disable=SC2034
[[ "$DEFAULT_DAYS" =~ ^[0-9]+$ ]] || DEFAULT_DAYS='90'

[[ -z "$DELETE_TYPE" ]] && DELETE_TYPE='batch'

check_variable()
{
	if [ -z "${!1}" ]; then
		echo "'$1', '-$2' is required!" >&2
		exit 1
	fi
}

check_variable 'AZURE_ACCOUNT_NAME' 'a'
check_variable 'AZURE_ACCOUNT_KEY' 'k'
