extends Node2D

tool
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var shader:NodePath
export var Load:bool setget start
var rot
# warning-ignore:unused_argument
func start(started):
	_ready()
# Called when the node enters the scene tree for the first time.
func _ready():
	var vectors = []
	for obj in get_tree().get_nodes_in_group("4DObject"):
		var data = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
		data[0]=obj.Size
		data[1]=[obj.translation.x,obj.translation.y,obj.translation.z,0]
		data[2]=[obj.rotation.x/2,obj.rotation.y/2,obj.rotation.z/2,obj.Boolean]
		var wRot = obj.wRotation
		data[3]=[wRot.x,wRot.y,wRot.z,obj.type]
		vectors.append(data)
	get_node(shader).material_override.set_shader_param("Data",makeTexture(vectors.size(),vectors))
	get_node(shader).material_override.set_shader_param("DataSize",vectors.size())
func makeTexture(width, vectors): # vectors is array of Color objects
		var w = 4
		var h = width
		var img = Image.new()
		img.create(w, h, false, Image.FORMAT_RGBAF)
		# put data into image
		img.lock()
		var x: int
		var y: int
		for i in range(0,vectors.size()):
# warning-ignore:unused_variable
			for p in range(0,4):
				y = i
				x = 0
				img.set_pixel(x+p, y, Color8(vectors[i][p][0],
				vectors[i][p][1],
				vectors[i][p][2],
				vectors[i][p][3]))
		img.unlock()
		var tex = ImageTexture.new()
		tex.create_from_image(img)
		return tex
