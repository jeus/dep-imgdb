#!/bin/sh

# Author : Ali Khandani
# Copyright (c) Lunatech

NEO4J_PATH='$HOME/docker-vm/neo4j'
#make data directory
mkdir -p  $NEO4J_PATH/import/imdb
mkdir -p  $NEO4J_PATH/conf

#Person Dataset
wget https://datasets.imdbws.com/name.basics.tsv.gz -P $NEO4J_PATH/import/imdb
#Role Dataset
wget https://datasets.imdbws.com/title.basics.tsv.gz -P $NEO4J_PATH/import/imdb
#Movie Dataset
wget https://datasets.imdbws.com/title.principals.tsv.gz -P $NEO4J_PATH/import/imdb


#decompress all tsv files.
gzip -d $NEO4J_PATH/import/*.gz


#Person
cat $NEO4J_PATH/import/imdb/name.basics.tsv | grep  $'^.const\|director\|actor\|actress' |  sed 's/"//g' > $NEO4J_PATH/import/imdb/person.basics.final.tsv

#solve problem in strings columns Movie
cat $NEO4J_PATH/import/imdb/title.basics.tsv | grep  $'^.const\|\tmovie'| sed 's/"//g'  > $NEO4J_PATH/import/imdb/title.basics.final.tsv


#principals process. <Role>
join -j 1 -o 1.1,1.2,1.3,1.4,1.5,2.1,2.2  $NEO4J_PATH/import/imdb/title.principals.tsv  $NEO4J_PATH/import/imdb/title.basics.tsv > $NEO4J_PATH/import/imdb/.tmp.title.principals.basic.tsv
cat $NEO4J_PATH/import/imdb/.tmp.title.principals.basic.tsv| grep  $'^.const\|movie' | cut -f -1 -d ' ' >  $NEO4J_PATH/import/imdb/.tmp.principals.codes.tsv
grep -F -f $NEO4J_PATH/import/imdb/.tmp.principals.codes.tsv  $NEO4J_PATH/import/imdb/title.principals.tsv > $NEO4J_PATH/import/imdb/.tmp.title.principals.fullcrew.tsv
cat $NEO4J_PATH/import/imdb/.tmp.title.principals.fullcrew.tsv | grep $'tconst\|director\|actor\|actress' | sed 's/"//g' >  $NEO4J_PATH/import/imdb/title.principals.final.tsv
rm -f $NEO4J_PATH/import/imdb/.tmp.title.principals.basic.tsv   $NEO4J_PATH/import/imdb/.tmp.principals.codes.tsv $NEO4J_PATH/import/imdb/.tmp.title.principals.fullcrew.tsv




