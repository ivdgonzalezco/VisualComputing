# Taller de interacción y shaders

## Objetivos

1. Estudiar las tareas universales de interacción en entornos virtuales.
2. Estudiar los [patrones de diseño de shaders](http://visualcomputing.github.io/Shaders/#/4).

## Desarrollo

Realizamos el taller construyendo un laberinto de 15 x 15 utilizando el algoritmo de Prim para generar aleatoriamente dicho laberinto, este algoritmo consiste en: 
  1. Inicializar una grilla de celdas, cada celda con los cuatro muros.
  2. Escoger aleatoriamente una celda de los bordes de la grilla y agregar sus vecinos a una lista general de celdas vecinas
  3. Escoger aleatoriamente una de las celdas vecinas y romper aleatoriamente un muro que conecte con un celda que ya pertenezca al laberinto y agregar a la lista las celdas vecinas. 
  4. El algoritmo termina cuando la lista general de vecinos esté vacía, entregando así un laberinto. 
  
 Al finalizar la construcción del laberinto este queda como una matriz de celdas, en donde cada celda guarda la información de los muros, si existe muro arriba, a la derecha, abajo, o a la izquierda, posteriormente se recorre la matriz y los muros son representados como cajas espichadas ( box(x,y,z), en processing ). 

Es posible visualizar el laberinto desde arriba moviéndose hacia adelante y hacia atrás, también es posible entrar en el laberinto y recorrerlo, esto lo hacemos utilizando un control de xbox conectado a la computadora. 

También es posible visualizar las sombras generadas por un punto de luz que pusimos en la parte superior derecha del laberinto. 

## Demo

[Ver el video aquí](https://www.youtube.com/watch?v=fA15IZPK-Gw)

## Integrantes

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
|Cristian Andres Garcia            | crigar             |
|Ivan Dario Gonzalez            | ivdgonzalezco             |


## Conclusiones 

1. Algunas de las figuras que vienen por defecto en Processing no se les pueden aplicar shaders normales.
2. La forma en la cual interactua el usuario es muy importante, dado que el usuario puede ir más alla dependiendo de las herramientas que se les den para interactuar con la escena.
3. La composición de las escenas es una de las partes mas importantes de este proceso, ya que el usuario sera guiado a traves de esta para interactuar, y donde los shader le daran más conocimiento acerca del entorno virtual el cual esta visitando.