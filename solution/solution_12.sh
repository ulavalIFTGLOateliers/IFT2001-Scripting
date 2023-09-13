grep Error messages.txt | uniq | sed 's/Error \(4[0-9]\+\)/Warning \1/g' > %\soloutpath%
