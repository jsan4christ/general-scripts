https://docs.github.com/en/github/authenticating-to-github/securing-your-account-with-two-factor-authentication-2fa/configuring-two-factor-authentication
https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token


# https://stackoverflow.com/questions/651038/how-do-i-clone-a-git-repository-into-a-specific-folder
git clone https://github.com/jsan4christ/Sars-Cov2-Refs.git ref
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
# 1) put the file git_filter_repo in a location that is in the PATH variable

# 2) Run the command below:
brew install git-filter-repo

git git-filter-repo --analyze

git filter-repo --strip-blobs-bigger-than 100M

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


###### Dealing with git large files: 
## https://stackoverflow.com/questions/19858590/issues-with-pushing-large-files-through-git
## https://github.com/newren/git-filter-repo
## Identify the large files

sudo cp /Users/sanemj/Temp/Bioinformatics/general-scripts/git-filter-repo /usr/local/bin/

python3 /usr/local/bin/git-filter-repo --analyze

cat .git/filter-repo/analysis/path-*.txt

# view files in more user friend format (file sizes)
exa --long Fig2/BA1_SA_New_edit_Rename_FinalSTEXP100ML.trees

# Remove large files from all commits without deleting it
git filter-branch --index-filter 'git rm -f --cached --ignore-unmatch Fig2/BA1_SA_New_edit_Rename_FinalSTEXP100ML.trees' HEAD

git commit -m "remove large file" 

git push --set-upstream origin main

# what if you have more than one file?
git filter-branch --index-filter 'git rm -f --cached --ignore-unmatch data/raw/genebank/sequence.gb data/raw/genebank/sequence.fasta data/raw/lanl/hiv-db.fasta' HEAD  ##if you have multiple

# Also see: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository

# WARNING: git-filter-branch has a glut of gotchas generating mangled history
# 	 rewrites.  Hit Ctrl-C before proceeding to abort, then use an
# 	 alternative filtering tool such as 'git filter-repo'
# 	 (https://github.com/newren/git-filter-repo/) instead.  See the
# 	 filter-branch manual page for more details; to squelch this warning,
# 	 set FILTER_BRANCH_SQUELCH_WARNING=1.
https://github.com/newren/git-filter-repo
https://github.com/newren/git-filter-repo/blob/main/INSTALL.md

#get the file
cd ~/Temp/Bioinformatics/general-scripts/

wget https://raw.githubusercontent.com/newren/git-filter-repo/main/git-filter-repo

# put the script in your path
sudo cp git-filter-repo /usr/local/bin/

# make sure it is executable
sudo chmod +x /usr/local/bin/git-filter-repo 

# write commands as specified in the documentation:
https://github.com/newren/git-filter-repo/blob/main/Documentation/converting-from-filter-branch.md#cheat-sheet-conversion-of-examples-from-the-filter-branch-manpage

git filter-repo

git filter-branch --index-filter 'git rm --cached --ignore-unmatch filename' HEAD

# All of these just become

git filter-repo --invert-paths --path filename

# for subdirectories
git filter-repo --to-subdirectory-filter newsubdir

##### install git lfs https://docs.github.com/en/repositories/working-with-files/managing-large-files/installing-git-large-file-storage
brew install git-lfs 

# Verify that the installation was successful / initialize in git directory.
git lfs install

git lfs track  Fig2/BA1_SA_New_edit_Rename_FinalSTEXP100ML.trees
