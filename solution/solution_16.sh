#!/usr/bin/env bash

cd ~/server

revert_last_commit() {
  git reset HEAD~1
}

exit_status=1
while [ $exit_status -ne 0 ]; do
  # Execute le script de test
  ~/test.sh > /dev/null 2>&1
  # Sauvegarde le status du script de test
  exit_status=$?

  if [ $exit_status -ne 0 ]; then
    echo "The script returned a non-zero exit status ($exit_status). Reverting commit and retrying..."
    revert_last_commit
  else
    echo "The script returned 0 (success)."
    exit 0
  fi

  # Add a delay between retries (optional)
  sleep 1
done
