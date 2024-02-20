#!/bin/bash

# ignore loading config.sh
# shellcheck disable=SC1091

# ignore vars from config.sh
# shellcheck disable=SC2154


# requires: https://github.com/keith/reminders-cli

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

. "${SCRIPT_DIR}"/config.sh
. "${SCRIPT_DIR}"/functions.sh

load_tasks

for task in $tasks ; do
  taskname=$(echo "$task" | cut -d : -f 2-  | cut -d ' ' -f 4- | tr \[\] \(\))
  taskpath=$(echo "$task" | cut -d : -f 1)

  if ! echo "$taskname" | grep -q 'id:' ; then
    # gen id
    # TODO: make this better maybe
    taskid=$(echo "${taskpath}":"${taskname}" | md5 | cut -b '1-6')

    # write id 
    sed -i.bak -re "s/${taskname}$/${taskname} id:${taskid}/g" "${taskpath}"
    #alt: echo perl -pi -e "s/- [ ] /- [x] / if $. == ${taskname} ${taskpath}" 

  fi

done

unset IFS
set +f
