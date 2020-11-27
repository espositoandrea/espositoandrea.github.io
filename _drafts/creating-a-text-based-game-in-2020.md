---
author: Andrea Esposito
title: Creating a Text-Based Game in 2020
lang: en
excerpt: >-
  During my Bachelor's studies, I rediscovered some very old games. I'm talking
  about those games like "Colossal Cave Adventure", where everything runs inside
  a terminal and uses only text. Let's create one of them in 2020!
---

During my Bachelor's studies, I rediscovered some very old games. I'm talking
about those games like
[_"Colossal Cave Adventure"_](https://en.wikipedia.org/wiki/Colossal_Cave_Adventure){:target="_blank",:rel="noopener noreferrer"},
where everything runs inside a terminal and uses only text. 

Usually, this kind of game it's based on a textual narration of a _dynamic_
story, in which the player decides what to do next, starting from a set of
predefined possible actions. It's clear that the stories were not actually
"_dinamic_": the player's actions simply modify the outcome of an event in one
way between a set of predefined ones. The action input is given by _writing_ a
command that the game executes.

My objective is simple: to recreate one of those games in a "modern" language
and to give it a more user-friendly "modern" interface (that doesn't force you
to type an entire command), while still keeping the text-based user interface.
But, we're Computer Scientist: actually, my goal is to create it in a way that
allows us to change the map and history of the game without modifying all the
rest of the source code. Basically, we want to create a "_framework_" for
text-based videogames.

## The Plan

Now, I'm not by any means a writer, let alone a game designer, but I still want
to work on this project. The solution is simple: I'll work on my "framework"
and I'll try it out by recreating an existing game. More precisely, I've chosen
to recreate the game ["L'Astronave
Condannata"](http://www.erix.it/avventure.html) (note that the website and the
original game are only available in Italian) by [Enrico
Colombini](http://www.erix.it/index.html), who I emailed to ask permission to
work on his project.

The original game was written in BASIC, an old programming language that dates
back to the 60s, and was published in 1997.
