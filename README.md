# GameProject

The **Production** branch will be where all feature branches will be merged.

Branches *Prototype*, *Alpha* and *Beta* are going to be snapshots of the game for those producion phases.

## Coding Conventions 

[Godot styleguide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)

*	We are going to be trying to follow the Godot coding conventions to the best of our ability for this project. 
*	We all know that following them is not always possible, so we are not going to be calling out every single failure to follow the conventions but if someone is not following them at all we’ll all sit down and discuss.
*	That said it is very important that the ***“Naming conventions”*** in the link above be followed religiously, because if they are not there is a significantly higher chance of bugs and breaks.

## Git Managing 

[Github management docs](https://docs.github.com/en/get-started/quickstart/github-flow) 

If at all possible ***only one person work on a scene at a time***
*	**Create a branch**, with your name if you don’t know what to put or the feature you’re going to be working on if you know which feature it is. If you are going to be working on something sensitive that others can not work on in parallel the add “-sensitive-XXX” where XXX is the sensitive part e.g. Object, level, etc.
*	**Make Changes**, anything you want to change you change and try to only work on whatever description you made in your branch name if at all possible so changes are easier to track.
*	**Commit** as often as you can while you work and push the changes to your branch when you are done making/adding changes.
*	**Create a pull request**, Create a pull request so other programmers/Tech lead can look through your work to check for any errors or possible complications you might have missed.
*	**Address review comments**, If any comments were made that need addressing in your pull request then you would handle those and make a new pull request when you are done.
*	**Merge your pull request**, when your pull request has been approved by another colleague then you can merge your branch to the production/main/working branch (pending).
*	**Delete your branch**, when you have merged your branch delete it so it doesn’t clutter our working environment.


## Godot version
We’re going to be using ***Godot version 4.1.2*** in this project.
