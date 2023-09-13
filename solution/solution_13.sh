find ~/Documents -type f | xargs du -sb | sort -rh | head -n 5 > ~/out_13.txt
# ou
find ~/Documents -type f | xargs du -sb | sort -h | tac | head -n 5 > ~/out_13.txt
# ou
find ~/Documents -type f | xargs du -sb | sort -h | tail -n 5 | tac > ~/out_13.txt
# ou
find ~/Documents -type f -exec du -sb {} + | sort -rh | head -n 5 > ~/out_13.txt
