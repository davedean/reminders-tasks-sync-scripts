# shellcheck shell=bash
# shellcheck disable=SC2059
# shellcheck disable=SC2034

# split vars at newline only
set -f              # turn off globbing
IFS='
'                   # split at newlines only

# where to load markdown tasks, file or folder
# if folder, all .md files in subfolders will be searched
mdfilesdir=./

mdnewtasksfile="${mdfilesdir}/newtasks.md"

# Reminders list name, to sync, all will sync "all"
listname=sync-testing
#listname=all #not implemented yet

# create list if it doesn't exist
if [ ! "$listname" == "all" ]; then
  if ! reminders show-lists | grep -q $listname ; then 
    reminders new-list $listname --source=iCloud
  fi
fi
