git checkout --orphan new_branch_name
git add -A
git commit -am "commit message"
git branch -D master
git branch -m master
git push -f origin master