Azure Old Blob Deletion
=======================

This script will delete all blobs in a storage account not modified for a
certain number of days.

The script will look for a number or the string `nodelete` on the end of the
container name, prefixed with a dash `-` and will delete any logs older than
the specified number of days.

 - `foo` means that files not modified for 90 days will be deleted.
 - `foo-nodelete` means the container will be skipped.
 - `foo-7` means that files not modified for 7 days will be deleted.
 - `foo7` means that files not modified for 90 days will be deleted.

The days can be specified by using the `-d` parameter.

The type of deletion can be changed by using the `-t` parameter:
  - `batch` (default): Send one `az` batch delete command (bugged at the
    moment. See: https://github.com/Azure/azure-cli/issues/6484)
  - `manual`: List all blobs, and manually delete each one by issuing an `az`
    command per item. Much slower. Note this method also requires `jq`.

Usage:

`delete-old-blobs -a 'myaccountname' -k 'myaccountkey' [-d 90] [-t manual|batch]`
