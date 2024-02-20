#!/bin/bash

# requires: https://github.com/keith/reminders-cli

# ignore loading config.sh
# shellcheck disable=SC1091

# ignore vars from config.sh
# shellcheck disable=SC2154

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

. "${SCRIPT_DIR}"/config.sh
. "${SCRIPT_DIR}"/functions.sh

load_tasks

load_reminders

# process each obsidian task
for task in $tasks ; do 
  taskname=$(echo $task | cut -d : -f 2-  | cut -d ' ' -f 4- | tr \[\] \(\))
  #taskpath=$(echo $task | cut -d : -f 1)
  taskid=$(echo $taskname | sed 's/.*id://g' | cut -d ' ' -f 1)

  # reminders only has three priorities, plus null
  # mad LOWEST and LOW to LOW
  if echo $taskname | grep -q ⏬ ; then
    priority_opt="--priority 1"
    # echo "p1"
  elif echo $taskname | grep -q 🔽 ; then
    priority_opt="--priority 1"
    # echo "p1"
  elif echo $taskname | grep -q 🔼 ; then
    priority_opt="--priority 2"
    # echo "p2"
  elif echo $taskname | grep -q ⏫ ; then
    priority_opt="--priority 3"
    # echo "p3"
  elif echo $taskname | grep -q 🔺 ; then
    priority_opt="--priority 3"
    # echo "p3"
  fi

  # if task is not in reminders, add it
  if ! echo $reminders_completed $reminders_incomplete | grep -q $taskid ; then
    taskname_noid=$(echo $taskname | sed 's/ id:.*//g')
    if echo $reminders_completed $reminders_incomplete | grep -q $taskname_noid ; then
      #echo "untagged $taskname exists, need to add id manually in reminders for now"
      line=$(reminders show "$listname" | grep $taskname_noid | cut -d : -f 1)
      index=$(echo $line | cut -d : -f 2)
      list=$(echo $line | cut -d : -f 1)

      reminders edit "$list" "${index}" "$taskname"
    else
      reminders add $listname $taskname ${priority_opt}
    fi
  fi

done

unset IFS
set +f
