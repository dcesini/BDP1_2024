######### login to the remote AWS server #################################
ssh -i <YUOR_AWS_KEY> ec2-user@<AWS_server_Public_IP>
sudo su -
##################################################################


################ Trivial Search ##################################

cp /data2/BDP1/trivial/trivial_str_search.py .
cp /data2/BDP1/trivial/shining.txt.gz .
gunzip -l shining.txt.gz
gunzip shining.txt.gz
md5sum shining.txt
cat /data2/BDP1/trivial/md5_shining.txt
vim trivial_str_search.py
./trivial_str_search.py



###### BLAST   #######
######################

#################### already installed ############################################
ll /data2/BDP1/hg19/ncbi-blast-2.7.1+-1.x86_64.rpm
# you need to be root
################ DO NOT USE THIS VERSION yum localinstall /data2/BDP1/hg19/ncbi-blast-2.7.1+-1.x86_64.rpm ############################
# IF IT WAS INSTALLED REMOVE IT: yum remove ncbi-blast-2.7.1+-1.x86_64

#### USE THIS ONE INSTEAD:
yum localinstall /data2/BDP1/hg19/ncbi-blast-2.15.0+-3.x86_64.rpm
###################################################################################

############## create the index for BLAST -  ALREADY DONE ##########################
#makeblastdb -in entire_hg19.fa -out entire_hg19BLAST -dbtype nucl  -parse_seqids
####### ALREADY DONE - DO not run it again!!!!!!!!!
##################################################################################
# INDEX is in /data2/BDP1/hg19/

ls -l /data2/BDP1/hg19/

########### get the query ###########################
cp /data2/BDP1/hg19/myread.fa .
#####################################################


############ run blast ########################################################
time blastn -db /data2/BDP1/hg19/entire_hg19BLAST -query myread.fa -out blast_myread.out
less blast_myread.out
###############################################################################

# Note: try to immediately repeat the command and not the differences
# you can also try the same excercise issuing this command between the two blastn runs:
#       sync; echo 1 > /proc/sys/vm/drop_caches
# this command drops the memory caches used by the kernel to limit disk access


############### BWA #####################
#########################################

####### Install your own bwa ########################
cp /data2/BDP1/hg19/bwa-0.7.15.tar .
################## already installed ##########
yum install gcc gcc-c++
yum install zlib
yum install zlib-devel
###############################################
tar -xvf bwa-0.7.15.tar
cd bwa-0.7.15/
# applied patch described here: https://github.com/lh3/bwa/commit/2a1ae7b6f34a96ea25be007ac9d91e57e9d32284
make 

# use your own bwa installation ###########
export PATH=$PATH:/your_path/bwa-0.7.15/
###########################################

############  BWA Istallation Completed #############################

##### bwa index creation - THIS IS ALREADY DONE ##########################
bwa index -p hg19bwaidx -a bwtsw entire_hg19.fa
##########################################################################
####### INDEX is in /data2/BDP1/hg19/ ###############################################

ls -ls /data2/BDP1/hg19/

cd ..  # back to home

# get the query ###########################
cp /data2/BDP1/hg19/myread.fa .
############################################

############## launch bwa ##################
bwa aln -t 1 /data2/BDP1/hg19/hg19bwaidx /your_path/myread.fa > myread.sai
bwa samse -n 10  /data2/BDP1/hg19/hg19bwaidx myread.sai myread.fa > myread.sam
less myread.sam
#####################################################################


################ READS LOCATION ####################################

ls -l  /data2/BDP1/hg19/reads/Patients

######################################################################
