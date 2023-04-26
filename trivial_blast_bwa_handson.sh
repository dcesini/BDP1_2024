######### login to the remote AWS server #################################
ssh -i <YUOR_GCP_KEY> <your_user>@<GCP_server_Public_IP>
sudo su -
##################################################################

# Download the tgz file with the data, 
wget <datafile link>   # launch this in a filesystem with enough space, i.e cd /data

#check the checksum
md5sum BDP1_2022.tgz    # must be 8fb4844e0b9d8a499bf5b39dc92f034f

# uncompress and untar the file
tar -xvzf BDP1_2022.tgz

################ Trivial Search ##################################

cp /data/BDP1_2022/trivial/trivial_str_search.py .
cp /data/BDP1_2022/trivial/shining.txt.gz .
gunzip -l shining.txt.gz
gunzip shining.txt.gz
md5sum shining.txt
cat /data/BDP1_2022/trivial/md5_shining.txt
vim trivial_str_search.py
./trivial_str_search.py



###### BLAST   #######
######################

#################### already installed ############################################
ll /data/BDP1_2022/hg19/ncbi-blast-2.7.1+-1.x86_64.rpm
# you need to be root
yum localinstall /data/BDP1_2022/hg19/ncbi-blast-2.7.1+-1.x86_64.rpm
###################################################################################

############## create the index for BLAST -  ALREADY DONE ##########################
makeblastdb -in entire_hg19.fa -out entire_hg19BLAST -dbtype nucl  -parse_seqids
##################################################################################
# INDEX is in /data/BDP1_2021/hg19/

ls -l /data/BDP1_2022/hg19/

########### get the query ###########################
cp /data/BDP1_2022/hg19/myread.fa .
#####################################################


############ run blast ########################################################
time blastn -db /data/BDP1_2022/hg19/entire_hg19BLAST -query myread.fa -out blast_myread.out
less blast_myread.out
###############################################################################

# Note: try to immediately repeat the command and not the differences
# you can also try the same excercise issuing this command between the two blastn runs:
#       sync; echo 1 > /proc/sys/vm/drop_caches
# this command drop the memory caches used by the kernel to limit disk access


############### BWA #####################
#########################################

####### Install your own bwa ########################
cp /data/BDP1_2022/hg19/bwa-0.7.15.tar .
################## already installed ##########
yum install gcc gcc-c++
yum install zlib
yum install zlib-devel
###############################################
tar -xvf bwa-0.7.15.tar
cd bwa-0.7.15/
make 

# use your own bwa installation ###########
export PATH=$PATH:/your_path/bwa-0.7.15/
###########################################

############  BWA Istallation Completed #############################

##### bwa index creation - THIS IS ALREADY DONE ##########################
bwa index -p hg19bwaidx -a bwtsw entire_hg19.fa
##########################################################################
####### INDEX is in /data/BDP1_2021/hg19/ ###############################################

ls -ls /data/BDP1_2022/hg19/

cd ..  # back to home

# get the query ###########################
cp /data/BDP1_2022/hg19/myread.fa .
############################################

############## launch bwa ##################
bwa aln -t 1 /data/BDP1_2022/hg19/hg19bwaidx /your_path/myread.fa > myread.sai
bwa samse -n 10  /data/BDP1_2022/hg19/hg19bwaidx myread.sai myread.fa > myread.sam
less myread.sam
#####################################################################


################ READS LOCATION ####################################

ls -l  /data/BDP1_2022/hg19/reads/Patients

######################################################################
