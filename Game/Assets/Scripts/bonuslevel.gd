extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const musicset = [
	"res://Assets/Audio/Frog/GameSong.mp3",
	"res://Assets/Audio/Space/GameSong.mp3",
	"res://Assets/Audio/Tapp/GameSong.mp3",
	"res://Assets/Audio/Gnop/GameSong.mp3",
	"res://Assets/Audio/MashBash/GameSong.mp3",
	"res://Assets/Audio/MashBash/WellHello.mp3",
	"res://Assets/Audio/MashBash/YoullBeMissed.mp3",
	"res://Assets/Audio/MashBash/TillNextTime.mp3",
	"res://Assets/Audio/MashBash/PartingWays.mp3"
]
const spritesset = [
	"res://Assets/Textures/Cake.png",
	"res://Assets/Textures/Health.png",
	"res://Assets/Textures/Enemy.png",
	"res://Assets/Textures/GameLogo.png",
	"res://Assets/Textures/PangBuffs.png",
	"res://Assets/Textures/PuzzleHook.png",
	"res://Assets/Textures/SpaceEnemy.png",
	"res://Assets/Textures/Cars0.png",
	"res://Assets/Textures/BuddyFace.png",
	"res://Assets/Textures/SpriteSheet.png",
	"res://Assets/Textures/Tapp/Barrel.png",
	"res://Assets/Textures/Tapp/Counter.png",
	"res://Assets/Textures/Tapp/Glass.png",
	"res://Assets/Textures/Tapp/Person0.png",
	"res://Assets/Textures/Tapp/Person1.png",
	"res://Assets/Textures/Tapp/Person2.png",
	"res://Assets/Textures/Tapp/Person3.png",
	"res://Assets/Textures/Tapp/Player.png"
]
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$MenuButton.add_item("SELECT SONG",0)
	$MenuButton.add_item("Boing-Boing",1)
	$MenuButton.add_item("ShipFight",2)
	$MenuButton.add_item("Barkeep",3)
	$MenuButton.add_item("Gnop",4)
	$MenuButton.add_item("MASHBASH",5)
	$MenuButton.add_item("WELL, HELLO",6)
	$MenuButton.add_item("YOU'LL BE MISSED",7)
	$MenuButton.add_item("TILL NEXT TIME",8)
	$MenuButton.add_item("PARTING WAYS",9)
	$MenuButton.text = "SONGS"
	$Sprites.add_item("CHOOSE SPRITE",0)
	$Sprites.add_item("CAKE",1)
	$Sprites.add_item("HEALTH",2)
	$Sprites.add_item("ENEMY",3)
	$Sprites.add_item("GAMELOGO",4)
	$Sprites.add_item("GNOPBUFFS",5)
	$Sprites.add_item("PUZZLEHOOK",6)
	$Sprites.add_item("SpaceENEMY",7)
	$Sprites.add_item("Cars",8)
	$Sprites.add_item("BUDDYFACE",9)
	$Sprites.add_item("FROGSHEET",10)
	$Sprites.add_item("BARREL",11)
	$Sprites.add_item("COUNTER",12)
	$Sprites.add_item("GLASS",13)
	$Sprites.add_item("PERSON0",14)
	$Sprites.add_item("PERSON1",15)
	$Sprites.add_item("PERSON2",16)
	$Sprites.add_item("PERSON3",17)
	$Sprites.add_item("PERSON4",18)


func _on_MenuButton_pressed():
	$MenuButton.get_popup().set_global_position($MenuButton.rect_global_position+Vector2(0,32))


func _on_MenuButton_item_selected(index):
	if index == 0:
		GlobalScene.stopmusic()
	else:
		GlobalScene.playmusic(musicset[index-1])


func _on_Sprites_pressed():
	$Sprites.get_popup().set_global_position($Sprites.rect_global_position+Vector2(0,32))


func _on_Sprites_item_selected(index):
	if index == 0:
		$Sprite.hide()
	else:
		$Sprite.show()
		$Sprite.texture = load(spritesset[index-1])
