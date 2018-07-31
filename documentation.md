---
title: "Documentation"
runtime: shiny
output: html_document
---

```{r setup, include=FALSE, echo = FALSE}
knitr::opts_chunk$set(echo = FALSE)
```
This shiny app is created with shiny and leaflet.
It consists of three main parts:
1. a map;
2. a table;
3. documentation


## Map
It shows a map of an area in the Netherlands with the monumental trees.
The user can choose the field that color or size are based on: Year planted of type of monumental tree
For the size it is most useful to choose year planted as an option as it will show the circle bigger the older the tree.
The histogram at the bottom shows the freqency of species shown in the map a it currently is displayed and is automtically updated
after each pan/zoom
The map can be panned and zoomed and the trees are clickable, it will show the species.

## Table
The table shows the rows that are selected witht the input from the select boxes
First the user can choose the type of tree, second the range of years it was planted.

The result is shown in the table below the input boxes.

## Documentation

This is the tab with the documentation on the shiny Tree app

The tree data is from:
https://data.overheid.nl/data/dataset/dpf-bomen-haarlemmermeer and is downloaded in csv format
The mapdata is from:
http://www.mapbox.com

The code for this app can be found on:




