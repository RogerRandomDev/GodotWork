extends Line2D

var startpos = Vector2.ZERO
var endpoint = Vector2.ZERO
var player:NodePath
var prevpoints = []
var done = false
var candie = false
# warning-ignore:unused_argument
func _process(delta):
	if not done:
		if get_node_or_null(player)!= null:
			points[points.size()-1] = get_node(player).position-position
			$RayCast2D.position = points[points.size()-2]
			$RayCast2D.cast_to = -points[points.size()-2]+points[points.size()-1]
			$RayCast2D.update()
			if $RayCast2D.is_colliding():
				if $RayCast2D.get_collider().name=="TileMap":
					default_color = Color.red
				else:
					default_color = Color(0,255,255,255)
				self.update()
	if done:
		self.remove_from_group("LinePuzzle")
		set_physics_process(false)
		set_process(false)
func addpoint(pos):
	points[points.size()-1] = pos-position
	add_point(pos-position)
