# Analisis_de_una_BDOG-DAW2
Análisis en Neo4j de una base de datos orientada a grafos basada en una red social con datos de Twitter de Neo4j con el algoritmo de Centralidad de Intermediación (Betweenness Centrality) del grupo de Centralidad (Centrality).

Figura 1. Ejemplo del grafo ![graph](https://user-images.githubusercontent.com/55488591/156415015-40a44f24-6ba7-4336-a9c7-b64f456add9b.png)


## Configuración

Esta configuración es para la versión de Neo4j Browser: 4.4.3

La base de datos está disponible en `https://demo.neo4jlabs.com:7473`

### Obtener la base de datos desde el  _Neo4j Desktop_ 

#### Para una conexión remota: 

  * La URL es `neo4j+s://demo.neo4jlabs.com`
  * El nombre de usuario y contraseña es `twitter`. 
  * El nombre de la base de datos es `twitter`.

#### Para una conexión local:

  * Crear un nuevo proyecto
  * Crear un nuevo DBMS local
  * Conectarlo y abrirlo
  * Importar la base de datos desde la consulta que se encuentra en este [repositorio](https://github.com/Ariadnadpd/BDOG_y_consulta-DAW2)

## Base de datos

Puede acceder a la base de datos [aquí](https://github.com/Ariadnadpd/BDOG_y_consulta-DAW2/blob/main/BD_twitter.json)

## Requerimientos del análisis

1. Obtener e importar una base de datos
2. Instalar las librerías `APOC` y `Graph Data Science Library`


## Cómo ejecutar el proyecto

Para ejecutar el proyecto, hay que hacer uso del fichero **Código para análisis.cypher** e ir ejecutando cada sentencia en el orden en el que van apareciendo. 

El **paso 4** es el algoritmo de centralidad de intermediación que se usa para medir el grado de influencia que un nodo o vértice posee dentro de un grafo:

```cypher
CALL gds.betweenness.mutate('miGrafo', { mutateProperty: 'betweenness' })
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten
```
Este algoritmo, para que funcione correctamente y de un resultado más preciso tiene que ser ejecutado tras haberse creado un grafo en el catalágo de grafos y haber hecho una estimación de memoria, tal y como se puede ver especificado en el fichero mencionado.

También se ha efectuado la ejecución de otros algoritmos aplicando técnicas de muestreo y cambiando la orientación del grafo para realizar una comparación de resultados. Estos se pueden ver a partir del **paso 6**.

