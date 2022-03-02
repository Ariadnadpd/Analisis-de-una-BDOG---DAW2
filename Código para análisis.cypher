// 1. Importación de la base de datos de la red social Twitter desde un repositorio en Github

CREATE CONSTRAINT ON(u:User)
ASSERT u.id IS unique;
:param keysToKeep => ["name", "username", "bio", "following", "followers"];
CALL apoc.load.json("https://raw.githubusercontent.com/Ariadnadpd/BDOG_y_consulta-DAW2/main/BD_twitter.json")
YIELD value
MERGE (u:User {id: value.user.id })
SET u += value.user
FOREACH (following IN value.following |  
  MERGE (f1:User {id: following})  
  MERGE (u)-[:FOLLOWS]->(f1))
FOREACH (follower IN value.followers |  
  MERGE(f2:User {id: follower})  
  MERGE (u)<-[:FOLLOWS]-(f2));


// 2. Creación o proyección de un grafo en el catálogo de grafos

CALL gds.graph.create('miGrafo', 'User', 'FOLLOWS')


// 3. Estimación de memoria para averiguar los requisitos de memoria

CALL gds.betweenness.write.estimate('miGrafo', { writeProperty: 'betweenness' })
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

CALL gds.betweenness.write.estimate('miGrafo', { writeProperty: 'betweenness', concurrency: 1 })
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory


// 4. Ejecución del algoritmo de centralidad de intermediación con el modo de ejecución mutate

CALL gds.betweenness.mutate('miGrafo', { mutateProperty: 'betweenness' })
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten


// 5. Listado del grafo en memoria tras la ejecución del algoritmo de centralidad

CALL gds.graph.list('miGrafo') YIELD graphName, schema



// Los siguientes algoritmos se han realizado aplicando otras técnicas para ver otros resultados y compararlos.

// 6. Ejecución del algoritmo con técnica de muestreo y modo de ejecución stream

CALL gds.betweenness.stream('miGrafo', {samplingSize: 5126, samplingSeed: 0})
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score
ORDER BY name ASC LIMIT 30

// Obtener el nodo con mayor puntuación
CALL gds.betweenness.stream('miGrafo', {samplingSize: 5126, samplingSeed: 0})
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score
ORDER BY score DESC LIMIT 1


// 7. Creación de un grafo no dirigido en el catálogo de grafos

CALL gds.graph.create('miGrafoNoDirigido', 'User', {FOLLOWS: {orientation: 'UNDIRECTED'}})


// 8. Ejecución del algoritmo de centralidad con el modo de ejecución stream en un grafo no dirigido

CALL gds.betweenness.stream('miGrafoNoDirigido')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score
ORDER BY name ASC LIMIT 30

// Obtener el nodo con mayor puntuación
CALL gds.betweenness.stream('miGrafoNoDirigido')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score
ORDER BY score DESC limit 1


