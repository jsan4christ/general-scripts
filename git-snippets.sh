https://docs.github.com/en/github/authenticating-to-github/securing-your-account-with-two-factor-authentication-2fa/configuring-two-factor-authentication
https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token

On new repo,

…or create a new repository on the command line

echo "# vmd" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/krisp-kwazulu-natal/vmd.git
git push -u origin main

…or push an existing repository from the command line

git remote add origin https://github.com/krisp-kwazulu-natal/vmd.git
git branch -M main
git push -u origin main

…or push an existing repository from the command line

git remote add origin https://github.com/krisp-kwazulu-natal/vmd.git
git branch -M main
git push -u origin main


## remove large files from commit
https://stackoverflow.com/questions/19858590/issues-with-pushing-large-files-through-git

https://stackoverflow.com/questions/24357108/updates-were-rejected-because-the-remote-contains-work-that-you-do-not-have-loca


hint: Using 'master' as the name for the initial branch. This default branch name
hint: is subject to change. To configure the initial branch name to use in all
hint: of your new repositories, which will suppress this warning, call:
hint: 
hint: 	git config --global init.defaultBranch <name>
hint: 
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
hint: 'development'. The just-created branch can be renamed via this command:
hint: 
hint: 	git branch -m <name>


Ignoring files
https://docs.github.com/en/get-started/getting-started-with-git/ignoring-files

Install the latest git on centos:
https://techglimpse.com/update-git-latest-version-centos/
https://packages.endpointdev.com/

## update refs
git update-ref -d refs/original/refs/heads/main

## Remove large files from all commits
git filter-branch --index-filter 'git rm -f --cached --ignore-unmatch data/raw/genebank/sequence.gb data/raw/genebank/sequence.fasta data/raw/lanl/hiv-db.fasta' HEAD