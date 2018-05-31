if [ $# -eq 0 ] || [ "$1" == "--help" ]; then
	echo "$(<"$BASE_DIR/help_message")"
	exit
fi

while getopts ":a: :k:" option
do
	case "${option}"
	in
		a) AZURE_ACCOUNT_NAME=${OPTARG};;
		k) AZURE_ACCOUNT_KEY=${OPTARG};;
		?) echo "Error: Invalid option was specified: ${OPTARG}";;
	esac
done

check_variable()
{
	if [ ! -n "${!1}" ]; then
		echo "'$1', '-$2' is required!" >&2
		exit 1
	fi
}

check_variable 'AZURE_ACCOUNT_NAME' 'a'
check_variable 'AZURE_ACCOUNT_KEY' 'k'
