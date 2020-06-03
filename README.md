how to run this code 
this file project `deployment` has two part 
`primary` directory that loading 3 files from IMDB to our Neo4J database
upload this files on neo4j

```
* name.basics.tsv
* title.basics.tsv
* title.principals.tsv
```
 `extended` directory that loading 4 files from IMDB to our Neo4j. Secondary files are not very important for our project. 
upload this files on neo4j
```
* title.akas.tsv
* title.crew.tsv
* title.episode.tsv
* title.ratings.tsv
```
##Step for install database. 

you first have to up docker-compose for runing neo4j.

1. config volume address on `docker-compose.yml` 
1. add below line to `$VOLUME/conf/neo4j.conf`
NOTE: be careful when you change configuration file it have to be compatible with your resources

```
   dbms.connector.bolt.address=0.0.0.0:7687
   dbms.memory.pagecache.size=8G
   dbms.memory.heap.initial_size:4G
   dbms.memory.heap.max_size:16G
   dbms.security.allow_csv_import_from_file_urls=true
   dbms.mode=CORE
   dbms.default_listen_address=0.0.0.0
   dbms.directories.import=import
   dbms.tx_log.rotation.retention_policy=100M size
```
1. run this command `docker-compose up -d neo4j` 
1. change `$NEO4j_PATH` variable in load-prime.sh
1. run load-prime.sh this script download files from IMDB server and copy and extract to `neo4j/import` directory 

1. when you be sure that files copy you can run command in `load-prime.sh`
1. download `cypher-shell` or use 'http://localhost:7474/browser/' for run commands in `load-prime.cypher` 

if you don't want have your database you can use mine. 
https://185.134.23.58:7474

I hope you be success. 


