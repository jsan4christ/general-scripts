# .bashrc
#echo "space left: " $(df -h | grep -w "data_commons-dscr-dhvi" | tr -s " " "\t" | cut -f 4)
# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

export CLICOLOR=1
export LSCOLORS="GxHxxxxxbxxxxxxxxxxxxx"

export EDITOR=/usr/bin/nano
#paths
export PATH=/opt/apps/bin:/opt/apps/perl.5.16.2/bin:$PATH
export IGDATA=$HOME/.local/igdata
export TERM=xterm
LS_COLORS="di=1;36"

# User specific aliases and functions

#alias python='/opt/apps/Python-2.7.3/bin/python2.7'
alias nano='nano -w'
alias common='srun -p common --mem=16G --pty bash -i'
alias dhvi='srun -p dhvi --mem=16G --exclude=dcc-dhvi-12 --pty bash -i'
alias dhvi1='srun -p dhvi --nodelist=dcc-dhvi-01 --mem=16000 --pty bash -i'
alias dhvi2='srun -p dhvi --nodelist=dcc-dhvi-02 --mem=16000 --pty bash -i'
alias dhvi3='srun -p dhvi --nodelist=dcc-dhvi-03 --mem=16000 --pty bash -i'
alias dhvi4='srun -p dhvi --nodelist=dcc-dhvi-04 --mem=16000 --pty bash -i'
alias dhvi5='srun -p dhvi --nodelist=dcc-dhvi-05 --mem=16000 --pty bash -i'
alias dhvi6='srun -p dhvi --nodelist=dcc-dhvi-06 --mem=16000 --pty bash -i'
alias dhvi7='srun -p dhvi --nodelist=dcc-dhvi-07 --mem=16000 --pty bash -i'
alias dhvi8='srun -p dhvi --nodelist=dcc-dhvi-08 --mem=16000 --pty bash -i'
alias dhvi9='srun -p dhvi --nodelist=dcc-dhvi-09 --mem=16000 --pty bash -i'
alias dhvi10='srun -p dhvi --nodelist=dcc-dhvi-10 --mem=16000 --pty bash -i'
alias dhvi11='srun -p dhvi --nodelist=dcc-dhvi-11 --mem=16000 --pty bash -i'
alias dhvi12='srun -p dhvi --nodelist=dcc-dhvi-12 --mem=16000 --pty bash -i'
alias dhviN8='srun -p dhvi --ntasks-per-node=8 --mem=16G --pty bash -i'
alias sq='squeue -u jsm56 -o"%.10i %.9P %.8j %.8u %.2t %.10M %.6D %C"'
alias mkdir='mkdir -m 775'
alias q='squeue -p dhvi'
alias w='watch -d -n 30 squeue -p dhvi'
alias locate='locate -d /hpc/group/dhvi/datacommons_locatedb'
alias checkcommon='echo "common partition";squeue -p common -o"%.10i %.10P %.10j %.6u %.3t %.15M %.6D %.3C %.15N" | grep jsm56'
alias watchcommon='watch -d "squeue -p common -u jsm56 "'
alias check='dhvi_partition_summary.pl'

#don't put duplicate lines in the history.
export HISTCONTROL=ignoredups
#history
export HISTSIZE=10000
export HISTFILESIZE=10000
#export -p HISTTIMEFORMAT='%m/%d/%Y %H:%M ' 

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}"'echo $USER "$(tty) $(history 1)" >> ~/.bash_eternal_history'


PS1="\[\e[35;1m\]\h:\w\$ \[\e[0m\]"

export LD_LIBRARY_PATH=/opt/apps/rhel7/cloanalyst:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/datacommons/dhvi/scripts/lib/boost/boost_1_70_0/stage/lib/:$LD_LIBRARY_PATH
export PYTHONPATH=/datacommons/dhvi/bin/lib/python/:${PYTHONPATH}
export PATH=/opt/apps/rhel7/openmpi-2.0.0/bin:$PATH
export PATH=/opt/apps/rhel7/mono-5.4.0.167/bin:$PATH
export CLOANALYST_PATH=/datacommons/dhvi/cloanalyst-linux-mpi/CloanalystPackage
export PATH=$PATH:/datacommons/dhvi/scripts/Perl
export PATH=$PATH:/datacommons/dhvi/scripts/Shell
export PATH=$PATH:/datacommons/dhvi/scripts/Compiled
export PATH=/hpc/home/jsm56/bin:$PATH
export PATH=/hpc/home/jsm56/.local/bin:$PATH
export PATH=/hpc/home/jsm56/samtools-1.9:$PATH

export PATH=/hpc/home/jsm56/igor_1-3-0/igor_src:$PATH
#export PATH=/dscrhome/sv177/igor_1-3-0:$PATH
#export PATH=/dscrhome/sv177/usr/igor/bin:$PATH
#export PATH=/dscrhome/sv177/igor_1-3-0/igor_src:$PATH

#redirect of tmp files
#mkdir -p /work/jsm56/tmp
export TMPDIR=/work/jsm56/tmp
export TMP=/work/jsm56/tmp
export TEMP=/work/jsm56/tmp

if true
then

if [[ $(uname -n) == "dcc-dhvi"* ]];
then
    echo "space left: " $(df -h | grep -w "/datacommons/dhvi" | tr -s " " "\t" | cut -f 4)
    #echo $(date +"%m-%d")  $(df -h | grep -w "/datacommons/dhvi" | tr -s " " "\t" | cut -f 4) >> ~/space_left.txt
    #uniq space_left.txt > ~/.spacetmp;
    #mv ~/.spacetmp ~/space_left.txt
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/hpc/group/dhvi/jsm56/minicoda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/hpc/group/dhvi/jsm56/minicoda3/etc/profile.d/conda.sh" ]; then
        . "/hpc/group/dhvi/jsm56/minicoda3/etc/profile.d/conda.sh"
    else
        export PATH="/hpc/group/dhvi/jsm56/minicoda3/bin:$PATH"
    fi
fi
unset __conda_setup
fi
# <<< conda initialize <<<

