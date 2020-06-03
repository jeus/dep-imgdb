
//Create name_basics --> Person
USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM "file:///imdb/person.basics.final.tsv" AS row FIELDTERMINATOR '\t' CREATE (:Person {uid: row.nconst, name: row.primaryName, birthYear: row.birthYear, deathYear: row.deathYear, primaryProfession: split(row.primaryProfession, ","), knownForTitles: split(row.knownForTitles, ",")});

//Create title_basics --> Movie
USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM "file:///imdb/title.basics.final.tsv" AS row FIELDTERMINATOR '\t' CREATE (:Movie {uid: row.tconst, type: row.titleType, name: row.primaryTitle, title: row.originalTitle, isAdult: row.isAdult, startYear: row.startYear, runtimeMinutes: toInteger(row.runtimeMinutes), genre: split(row.genres, ",")});

//Create title_principals
USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM "file:///imdb/title.principals.final.tsv" AS row FIELDTERMINATOR '\t' CREATE (:Role {uid: row.tconst, nconst: row.nconst, category: row.category, job: row.job, characters: split(row.characters, ",")});


// Add index
CREATE INDEX ON :Movie(uid);
CREATE INDEX ON :Role(uid);
CREATE INDEX ON :Person(uid);


//Create Relationship between name_basics and title_principals
//This Query needs to be executed multiple times!
MATCH (a:Person) WITH a MATCH (b:Role {nconst: a.uid , category: 'director'}) WHERE NOT (a)-->(b) WITH a, b LIMIT 1000000 MERGE (a)-[r:DIRECTED]->(b)
MATCH (a:Person) WITH a MATCH (b:Role {nconst: a.uid , category: 'actor'}) WHERE NOT (a)-->(b) WITH a, b LIMIT 1000000 MERGE (a)-[r:ACTED_IN]->(b)

//Create Relationship between title_basics and name_basics
//This Query needs to be executed multiple times by consider your resource and count of name_basics
MATCH (a:Person) UNWIND a.knownForTitles as knownForTitle MATCH(b:Movie {uid: knownForTitle}) WHERE NOT (a)-->(b) WITH a, b LIMIT 1000000 MERGE(a)-[r:KNOWN_FOR]->(b)


//Create Relationship between title_basics and title_principals
//This Query needs to be executed multiple times!
MATCH (a:Movie) WITH a MATCH (b:Role {uid: a.uid}) WHERE NOT (b)-[:WORKED_ON]->(a) WITH a, b LIMIT 1000000 MERGE (b)-[r:WORKED_ON]->(a)

//This Query needs to be executed multiple times!
//Make short relationship between actor and movie.
MATCH (n:Person)-[r:AS_A]->(t:Role)-[w:WORKED_ON]->(m:Movie) WHERE NOT (n)-->(m) AND t.category In ['actor','actress'] and t.characters IS NOT NULL  WITH n, m limit 1000000 MERGE (n)-[d:ACTED_IN {characters: t.characters , category: t.category}]->(m)
MATCH (n:Person)-[r:AS_A]->(t:Role)-[w:WORKED_ON]->(m:Movie) WHERE NOT (n)-[:ACTED_IN]->(m) AND t.category In ['actor','actress'] and t.characters IS NULL WITH n, m ,t limit 1000000 MERGE (n)-[d:ACTED_IN {category: t.category}]->(m)

//This Query needs to be executed multiple times!
//Make short relationship between direoctor and movie.
MATCH (n:Person)-[r:AS_A]->(t:Role)-[w:WORKED_ON]->(m:Movie) WHERE NOT (n)-[:ACTED_IN]->(m) AND t.category = 'director' WITH n, m limit 1000000 MERGE (n)-[d:DIRECTED {category: t.category}]->(m)

//This Query needs to be executed multiple times!
//Make short relationship between writer and movie.
MATCH (n:Person)-[r:AS_A]->(t:Role)-[w:WORKED_ON]->(m:Movie) WHERE NOT (n)-[:ACTED_IN]->(m) AND t.category = 'writer' WITH n, m limit 1000000 MERGE (n)-[d:WRITED]->(m)



//This Query needs to be executed multiple times!
//DELETE orphan title_principals
//This commands run for get more precise result when there same name in database.
MATCH (n:Movie {startYear: '\\N'})  SET n.startYear = NULL
MATCH(n:Person) where n.birthYear = '\\N' SET n.birthYear = NULL
MATCH(n:Person) where n.deathYear = '\\N' SET n.deathYear = NULL














