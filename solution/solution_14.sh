awk '{print $5 " " $3}' db.tsv | sort -h | head -n 10 | awk '{print $2}' > ~/out_14.txt
# ou
awk '{print $5 " " $3}' db.tsv | sort -h | head -n 10 | sed 's/^[^ ]* //' > ~/out_14.txt
