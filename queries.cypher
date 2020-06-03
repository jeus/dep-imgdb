MATCH (n:name_basics)-[t:ACTED_IN]->(m:title_basics) return n,t,m limit 100


MATCH (n:name_basics) set n:Person
MATCH (n:Person) REMOVE n:name_basics
MATCH (n:Person) REMOVE n:Processed9

MATCH (n:title_basics) set n:Movie
MATCH (n:Movie) REMOVE n:title_basics
MATCH (n:Movie) REMOVE n:Processed4

MATCH (n:title_principals) set n:Role
MATCH (n:Role) REMOVE n:Processed1
MATCH (n:Role) REMOVE n:Processed8
MATCH (n:Role) REMOVE n:title_principals

MATCH (n:Role) REMOVE n:title_principals return count(n)

//RENAME LABEL:
MATCH (n:Person)-[r:ACTED_IN]->(m:Role)  CREATE (n)-[r2:AS_A]->(m)  SET r2 = r  WITH r  DELETE r


//Convert String to array.
MATCH (n:Role) where n.characters IS NOT NULL WITH replace(n.characters[0],"[",'') as b , n WITH replace(b,"]",'') as c , n WITH  replace(c,'"','') as d , n SET n.characters = split(d,',')