#!/usr/bin/env bash

# Author : Ali Khandani
# Copyright (c) Lunatech

wget https://datasets.imdbws.com/title.akas.tsv.gz -P $NEO4J_PATH/import
wget https://datasets.imdbws.com/title.crew.tsv.gz -P $NEO4J_PATH/import
wget https://datasets.imdbws.com/title.episode.tsv.gz -P $NEO4J_PATH/import
wget https://datasets.imdbws.com/title.ratings.tsv.gz -P $NEO4J_PATH/import


#decompress all tsv files.
gzip -d $NEO4J_PATH/import/*.gz