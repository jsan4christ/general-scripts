Commands to remove files that are already committed.
mv .idea ../.idea_backup
rm .idea # in case you forgot to close your IDE
git rm -rf .idea 
git commit -m "Remove .idea from repo"
git remote | xargs -L1 git push --all
mv ../.idea_backup .idea

Also add to .gitignore or .gitignore_global

Other committers should run
git pull

Or just tell git to not assume it is changed never matter what:
git update-index --assume-unchanged src/file/to/ignore

git reset --hard HEAD^1 (the commit just before HEAD) or Or you can get the hash of a previous known working commit with git log, then git reset --hard <hash>

git ls-tree --full-tree -r HEAD //list already committed files being tracked by git

git ls-files //all files in repo including those staged but not committed


git rm -r --cached .   //or specifically file/directory
* rm is the remove command
* -r will allow recursive removal
* –cached will only remove files from the index. Your files will still be there.
git add .    //to read
git commit -m ".gitignore fix" //commit git ignore

To create global ignore files then edit the file accordingly
 git config --global core.excludesfile ~/.gitignore_global

https://help.github.com/articles/removing-sensitive-data-from-a-repository/ removing sensitive	data

https://pad.carpentries.org/2018-09-03-CarpentryConnect-JHB-SWC-GIT
https://www.git-tower.com/blog/git-cheat-sheet

cd /path/to/gitea
./gitea admin change-password --username myusername --password asecurenewpassword



./gitea admin --help

https://docs.gitea.io/en-us/

https://bryangilbert.com/post/devops/how-to-setup-gitea-ubuntu/
https://golb.hplar.ch/2018/06/self-hosted-git-server.html

https://docs.gitea.io/en-us/command-line/

Gitea on KRISP2:
Create git user:
If exists, drop:  sudo userdel -r git //to delete and the user’s home directory and mail spool. If process is using it: sudo kill -9 process_id

sudo useradd --system -d /data/users/home/git --create-home  git

Leaving out --shell /bin/bash, as this is already the default shell i.e echo $SHELL otherwise, set

# Create directory structure and permission
mkdir -p  /data/users/home/git/gitea/{custom,data,log}
chown -R git:git /data/users/home/git/gitea/ #Not necessary if everything done under the user git
chmod -R 750 /data/users/home/git/gitea/.   #Necessary to write configuration
mkdir /etc/gitea
chown root:git /data/users/home/git/gitea/custom/conf
chmod 750 /data/users/home/git/gitea/custom/conf #initially to enable writing the config
chmod 644 /data/users/home/git/gitea/custom/conf/app.ini #Make the configuration file read only after installation



./gitea web -p 8085

Install location: /data/users/home/git/gitea/ installed version 1.9
To Restart: 	sudo systemctl start gitea
To Stop: 		sudo systemctl stop gitea


git reflog  //Git log of previous commits

git reset --hard 60d404e //revert to commit

git checkout 60d404ea18a7ab20a2f3ad198c1f9ee7278b2c17  //to get remote commit

https://docs.gitea.io/en-us/linux-service/
———
[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target
After=network.target
#Requires=mysql.service
#Requires=mariadb.service
Requires=postgresql.service
#Requires=memcached.service
#Requires=redis.service

[Service]
# Modify these two values and uncomment them if you have
# repos with lots of files and get an HTTP error 500 because
# of that
###
#LimitMEMLOCK=infinity
#LimitNOFILE=65535
RestartSec=2s
Type=simple
User=git
Group=git
#WorkingDirectory=/var/lib/gitea/
WorkingDirectory=/data/users/home/git/gitea/ 
ExecStart=/data/users/home/git/gitea/gitea web -c /data/users/home/git/gitea/custom/conf/app.ini
Restart=always
Environment=USER=git HOME=/data/users/home/git/  GITEA_WORK_DIR=/data/users/home/git/gitea/
# If you want to bind Gitea to a port below 1024 uncomment
# the two values below
###
#CapabilityBoundingSet=CAP_NET_BIND_SERVICE
#AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
———

## Backup postgres database




#Edit:
crontab -e (see https://tecadmin.net/crontab-in-linux-with-20-examples-of-cron-schedule/)
0 19 * * * pg_dump -U postgres gitea > /data1/sys_backup/PostgresDb/gitea.bak #Back up at 7pm daily
G

## Checkout code that you have not committed into a new branch and leave the original branch e.g master clean
https://stackoverflow.com/questions/2569459/git-create-a-branch-from-unstaged-uncommitted-changes-on-master
git checkout -b jetty


Git Repository Setup:

Create remote repo,

Initialize git in local repo	
	git init 
	git add -A
	git commit -m  “initial commit”
	git branch -m master main
Add remotes
	git remote add origin https://github.com/krisp-kwazulu-natal/update_pangolin_json.git
Sync up remote and local repo
	git status
	git add -A
	git commit -m  "Initial commit"
	git push origin main

Quick commands:
	git remote //view remote branch
	git branch //view current brunch
	

fatal: refusing to merge unrelated histories
git pull origin main --allow-unrelated-histories


//fatal: The remote end hung up unexpectedly
git config http.postBuffer 524288000

https://stackoverflow.com/questions/40063332/git-tries-to-upload-deleted-file-that-is-not-staged
git reset --soft "HEAD^"
# potentially modify the tree content
# amend the old commit with the file removed:
git commit --amend

https://git-lfs.github.com/


echo "# mozambique_genomic_epi_analysis" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/CERI-KRISP/mozambique_genomic_epi_analysis.git
git push -u origin main
…or push an existing repository from the command line

git remote add origin https://github.com/CERI-KRISP/mozambique_genomic_epi_analysis.git
git branch -M main
git push -u origin main
…or import code from another repository
You can initialize this repository with code from a Subversion, Mercurial, or TFS project.


Git commit only new and modified files ignoring the untracked files:
git commit -am "commit message"

Or:
git add -u to stage already tracked files that have been modified since last commit.

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


# Ignoring files
# https://docs.github.com/en/get-started/getting-started-with-git/ignoring-files

#Install the latest git on centos:
#https://techglimpse.com/update-git-latest-version-centos/
#https://packages.endpointdev.com/

## update refs
git update-ref -d refs/original/refs/heads/main

## Remove large files from all commits
git filter-branch --index-filter 'git rm -f --cached --ignore-unmatch data/raw/genebank/sequence.gb data/raw/genebank/sequence.fasta data/raw/lanl/hiv-db.fasta' HEAD