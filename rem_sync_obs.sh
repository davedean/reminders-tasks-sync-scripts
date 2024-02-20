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
  taskpath=$(echo $task | cut -d : -f 1)
  taskid=$(echo $taskname | sed 's/.*id://g' | cut -d ' ' -f 1)

  echo processing $taskname
  # if task is in reminders, update it in tasks
  if echo $reminders_completed $reminders_incomplete | grep -q $taskid ; then
    for reminder in $reminders_completed $reminders_incomplete ; do
      if echo $reminder | grep -q id:$taskid ; then
        # TODO
        if [ ! "$reminder" == "$taskname" ] ; then
          echo update me: $reminder, was: $taskname
          #echo update me: $(echo $reminder | md5sum), was: $(echo $taskname | md5sum)
          sed -i.bak -re "s/${taskname}$/${reminder}/g" "${taskpath}"
        fi
      fi
    done 

  else 
    # not found? need to add it to reminders. TODO, decide if this even makes sense?
    echo Task ${taskid} not found in reminders. Advise running obs_to_rem.sh to sync obs tasks to reminders.
  fi

done

# now go through reminders, and see if any are not in tasks.
# TODO
for reminder in $reminders_completed $reminders_incomplete ; do
  reminderid=$(echo $reminder | sed 's/.*id://g' | cut -d ' ' -f 1)

  if ! echo $reminder | grep -q ' id:' ; then
    echo $reminder has no id? adding to obsidian without id.

    echo "- [ ] ${reminder}" >> "$mdnewtasksfile"
  else 
    if ! echo "$tasks" | grep -q "$reminderid" ; then
      echo "$reminder" not in tasks? adding.
      echo "- [ ] ${reminder}" >> "$mdnewtasksfile"
    fi
  fi
  
done

unset IFS
set +f
