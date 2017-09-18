#Dcriptiopn    :  Script to create volumes in the MapR cluster with different parameters
# Author       : Selvaraaju Murugesan
# Date         : 18/09/2017
# Authorsed by :
# Last Modified:
# Audi Log     :
# ======================================================================================:w

#Some basic information about the cluster
clear

#Create volumes CMTEDD, TCCS, Health, JACS, CSD , AccessCanberra, IBS, SandPit
maprcli volume create -name CMTEDD -path /data -type rw
maprcli volume audit -name CMTEDD -enabled true

maprcli volume create -name CSD -path /data -advisoryquota 100M -quota 500M -type rw
maprcli volume audit -name CSD -enabled true

maprcli volume create -name TCCS -path /data -type rw
maprcli volume audit -name TCCS -enabled true

maprcli volume create -name CSD -path /data -type rw
maprcli volume audit -name CSD -enabled true

maprcli volume create -name SandPit -path /data -type rw
maprcli volume audit -name SandPit -enabled true

maprcli volume create -name JACS -path /data -type rw
maprcli volume audit -name JACS -enabled true

maprcli volume create -name AccessCanberra -path /data/CMTEDD -type rw
maprcli volume audit -name AccessCanberra -enabled true

maprcli volume create -name IBS -path /data/CMTEDD/IBS -type rw
maprcli volume audit -name IBS -enabled true

hadoop fs -mkdir /data/CMTEDD/IBS/Landing
hadoop fs -mkdir /data/CMTEDD/IBS/Processed
