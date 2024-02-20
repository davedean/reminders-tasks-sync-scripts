# reminders-tasks-sync-scripts
Sync obsidian tasks and Apple Reminders


## THIS IS VERY ALPHA DO NOT USE ##


Have needed this for a while, but kept over-doing it. 

These scripts are an attempt to keep things "mostly simple".

They're probably opinionated around how I do things.

## Install

0. Install https://github.com/keith/reminders-cli

1. Copy these scripts somewhere

2. Edit config.sh

- point to your obsidian tasks folder or file
- point to the reminders list you want to use (or set to all)

Run scripts and hope nothing goes wrong.


## Usage 

- obs_id_tasks.sh, add `id:` tags to tasks in obsidian so scripts can track them
- obs_to_rem.sh, copy markdown tasks to reminders or update existing ones
- rem_sync_obs.sh, copy reminders to markdown tasks or update existing ones 


ignore these:

- config.sh, contains config used by other scripts
- functions.sh, contains functions used by other scripts
