# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if ( echo `hostname` | grep -sq 'cc' ); then
  export DISPLAY=:0.0
fi

export LD_PRELOAD=""
export PATH="/lus/theta-fs0/projects/visualization/vray/bin/":$PATH
export LD_LIBRARY_PATH="/lus/theta-fs0/projects/visualization/vray/lib/":$LD_LIBRARY_PATH
