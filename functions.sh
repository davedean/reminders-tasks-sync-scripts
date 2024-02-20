#!/bin/bash

# load_tasks
load_tasks () {
  # get obsidian tasks
  #tasks=$(grep -Hr '\-\ \[\ \]\ ' "${mdfilesdir}" )
  tasks=$(find . -name '*.md' -exec  grep  -Hr '\-\ \[\ \]\ ' {} \;)
}
export -f load_tasks

load_reminders () {
  # fetch list contents or create list if it doesn't exist
  if [ "$listname" == "all" ] ; then
    reminders_completed=$(reminders show-all --only-completed  | cut -d ' ' -f 2- )
    reminders_incomplete=$(reminders show-all | cut -d ' ' -f 2-)
  else 
    reminders_completed=$(reminders show "$listname" --only-completed  | cut -d ' ' -f 2- )
    reminders_incomplete=$(reminders show "$listname" | cut -d ' ' -f 2-)
  fi
}
export -f load_reminders
