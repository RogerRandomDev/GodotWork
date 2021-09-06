extends Node2D


#Variable purposes: ModulePosition is current height, to tell how high you are at the moment
#currentModules says how many exsist so we know when to remove the earliest module
#nextModule says what ModulePosition will be before creating a new module
#blockSize say the tile size for blocks
#moduleHeight maintains what the block count is vertically for each section
#ModuleID is current modules ID
var ModulePosition = 1152
var currentModules = 0
var nextModule = 0
var moduleProgress = 0
var blockSize = 64
var moduleHeight = [8,12,6,7,14]
var ModuleID = 0

func _ready():
	randomize()

# warning-ignore:unused_argument
func _process(delta):
	##creates new modules when you go up and removes the lowest one to maintain efficiency over time
	if ModulePosition > nextModule:
		ModuleID = round(rand_range(0,moduleHeight.size()-1))
		var Module = load("res://Assets/Scenes/MapModules/"+str(ModuleID)+".tscn").instance()
		add_child(Module)
	#positions Modules
		Module.position.y = -nextModule+32
	#sets the point to create a new module at
		nextModule += moduleHeight[ModuleID]*blockSize
		moduleProgress+=1
		currentModules+=1
	#removes earliest module past a certain number of them
	if currentModules > 12:
		get_child(1).queue_free()
		currentModules-=1
