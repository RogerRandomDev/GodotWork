//README MADE BY ROGER GRANGE//
//README was made to show my thoughts while working on this//

Ok, so I never made a README before, so I'll do my best here at explaining things.

First things first, I'll explain what each scene is and what filetypes go to what.

//
GD-Scripts, a sort of mix between python and c#, designed for godot.
TSCN-Scenes, the things you look at visually that the objects and scripts are put into.
TRES-Data files, used for storage of things ranging from tile sets, to just straight up text files if you so wish.
TTF-Font data.
SHADER-shader. the name says it all.
//

Okay, so from here i'll actually explain what each file is doing broadly to keep it short.

//SCRIPTS//

Player.gd-Runs player motion and player inputs during the main game

GlobalData.gd-Keeps all data stored globally for pulling even after switching scenes.

ModuleLoader.gd-Tasked with loading the map chunks as you move and unloading lower ones as you progress upwards.

BaseGame.gd-deals with the startup of the games main scene.

RoadMotion.gd-deals with the moving objects and is designed to be modular and to easily add more designs

Title.gd-deals with the title screen and its inputs


//SCENES//

MapModules-everything in here is a modular chunk that is loaded in and out using ModuleLoader.gd as you move.

ModuleLoader.tscn-Deals with the modules to keep things from getting hectic inside the scenes from node errors

BaseGame.tsc-The main game scene, has the actual basic game itself

Player.tscn-The player, kept as a scene for easier editing as neccessary

Sliders.tscn-The moving vehicles kept here for easier changing without editing all modules manually

Title.tscn-The title screen

//SHADERS//

FinalShader.shader- a shader i've worked on for another game, made using two other shaders as a base, a vhs shader and a crt shader, resulting in a nice retro, old television feel to the final output.

//COMMENTS//

Honestly, while I DID make this for the FBLA, I just had a blast making it in the end.

It was fun trying something new.

The coding was my favorite part, while art was second.

Music however, was extremely hard as I wanted to keep the feel of it being an old arcade game, so i had to work with that in mind and I'm not good at music in the first place.

Anyways, hope you have and/or will enjoy this little game I made with the rest of my team. They were a great help in everything we did to make the final output.
