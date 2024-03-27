DCC:

ssh jes183@dcc-login.oit.duke.edu

ssh jes183@dcc-login.oit.duke.edu

module avail
module load

# You can add the module load command to your job scripts, or to the end of the .bash_profile file in your home directory.

export PATH="/hpc/group/dhvi/jsm56/minicoda3/bin:$PATH"

 $(df -h | grep -w "/datacommons/dhvi" | tr -s " " "\t" | cut -f 4)