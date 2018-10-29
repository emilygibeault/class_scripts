#!/bin/bash
echo "This is a bash script to do multiple sequence alignment with muscle and phylogenetic tree construction with RAxML. Welcome!"

#Set up variables
infile='data/co1.fa'
outfile='out.phy'
jobname='tree1'
mu_maxiters=10

#Trim taxon names out of fasta header
cat $infile | sed"s/[|]//g" | awk -F " " '{if($2 ~ /[A-Za-z_0-9]/){print ">" $2}else{print $0}}' > trim.fa

wcin=$(cat trim.fa | wc -m)

./muscle -in trim.fa -phyiout $outfile -maxiters $mu_maxiters -N 100

wcout=$(cat $outfile | wc -m)

wcchange=$(expr $wcout - $wcin)

echo "Muscle added $wcchange characters.\n"


./raxml -f a -p 12345 -x 12345 -N 100 -s out.phy -m GTRCAT -n boot1 -T2

./raxml -f b -t ref -z RAxML_bootstrap.boot1 -m GTRCAT -n consensus -T 2

echo "RAxML Finished!"

#remove intermediate files:
rm trim.fa
