#!/usr/bin/env bash

# This sets the number of nodes.
#SBATCH -N 1                                                                       
 
# This sets the number of processors per node.
#SBATCH --ntasks-per-node=8                                                        
#SBATCH --mem-per-cpu=8000                                                         
 
# This sets the total maximum runtime.                                             
#SBATCH -t 1:59:00                                                                 

# Sends an email when the process begins and when it ends.                         
#SBATCH --mail-type=begin                                                          
#SBATCH --mail-type=end                                                            
#SBATCH --mail-user=USER@princeton.edu                                             

module load openmpi

set -e # Abort when anything returns a nonzero (error) status.

app=myicoFoam # Application to run.
np=8 # Number of cores.
date=$(date +%Y_%m_%d_%H_%M_%S) # Current date/time.
logfile="${app}_${date}.log" # Name of log file.

# Case directory. In a real run, maker sure to run from /scratch/network/$USER
cd /scratch/network/USER/Yjunction

# Commands to be run from case directory.
date > $logfile
echo "Removing old data." >> $logfile
rm -rf VTK processor*

date >> $logfile
make >> $logfile 2>&1

date >> $logfile
setInletVelocity >> $logfile 2>&1

date >> $logfile
decomposePar >> $logfile 2>&1

date >> $logfile
srun $app -parallel >> $logfile 2>&1

date >> $logfile
reconstructPar >> $logfile 2>&1

date >> $logfile
foamToVTK >> $logfile 2>&1

date >> $logfile
rm -rf processor*