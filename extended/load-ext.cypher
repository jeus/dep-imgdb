//Create title_ratings
USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM "file:///title.ratings.tsv" AS row FIELDTERMINATOR '\t' CREATE (:title_ratings {tconst: row.tconst, numVotes: toInteger(row.numVotes), averageRating: toFloat(row.averageRating)});

//Create title_episode
USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM "file:///title.episode.tsv" AS row FIELDTERMINATOR '\t' CREATE (:title_episode {tconst: row.tconst, parentTconst: row.parentTconst, seasonNumber: toInteger(row.seasonNumber), episodeNumber: toInteger(row.episodeNumber)});

//Create title_crew
USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM "file:///title.crew.tsv" AS row FIELDTERMINATOR '\t' CREATE (:title_crew {tconst: row.tconst, directors: split(row.directors, ","), writers: split(row.writers, ",")});

//Create title_akas
USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM "file:///title.akas.tsv" AS row FIELDTERMINATOR '\t' CREATE (:title_akas {titleID: row.titleID, ordering: toInteger(row.ordering), title: row.title, region: row.region, language: row.language, types: split(row.types, ","), attributes: split(row.attributes, ","), isOriginalTitle: row.isOriginalTitle});


CREATE INDEX ON :title_crew(tconst);
CREATE INDEX ON :title_ratings(tconst);
CREATE INDEX ON :title_episode(tconst);
CREATE INDEX ON :title_akas(titleID);


//Create Relationship between title_basics and title_ratings
MATCH (a:title_basics) WITH a MATCH (b:title_ratings) WHERE a.tconst = b.tconst CREATE (a)-[r:HAS_RATING]->(b);

//Create Relationship between title_basics and title akas
// This Query needs to be executed multiple times!
MATCH (a:title_basics) WITH a MATCH (b:title_akas {titleID: a.tconst}) WHERE NOT b:Processed WITH a, b LIMIT 1000000 MERGE (a)-[r:HAS_TITLE_AKA]->(b) SET b:Processed;


//Create Relationship between title_basics and title_episode
//This Query needs to be executed multiple times!
MATCH (a:title_basics) WITH a MATCH (b:title_episode {parentTconst: a.tconst}) WHERE NOT b:Processed2 WITH a, b LIMIT 1000000 MERGE (a)-[r:HAS_SEASON]->(b) SET b:Processed2;

//Create relationship between title_crew and title_basics
//This query is not necessary
MATCH (a:title_crew) UNWIND a.writers as writer MATCH (b:title_basics {tconst: a.tconst}) WHERE NOT b:Processed5 WITH a, b LIMIT 1000000 MERGE (b)-[r:HAS_WRITER]->(a) SET b:Processed5;


//Create Relationship between title_crew and title_basics
//This Query needs to be executed multiple times!
MATCH (a:title_crew) UNWIND a.directors as director MATCH (b:title_basics {tconst: a.tconst}) WHERE NOT b:Processed7 WITH a, b LIMIT 1000000 MERGE (b)-[r:HAS_DIRECTOR]->(a) SET b:Processed7;


// After all relationships are created remove temporary nodes
// Run this query multiple times at the end of the relationship creation
MATCH (n:Processed) WITH n LIMIT 500000 REMOVE n:Processed;

