extends Line2D

var startpos = Vector2.ZERO
var endpoint = Vector2.ZERO
var player:NodePath
var prevpoints = []
var done = false
var candie = false
var stopped = false
var latestpoint:NodePath
# warning-ignore:unused_argument
func _process(delta):
	if not done:
		if get_node_or_null(player)!= null and !stopped:
			points[points.size()-1] = get_node(player).position-position
			$RayCast2D.position = points[points.size()-2]
			$RayCast2D.cast_to = -points[points.size()-2]+points[points.size()-1]
			$RayCast2D.update()
			if $RayCast2D.is_colliding():
				if $RayCast2D.get_collider().name=="TileMap":
					if candie:
						default_color = Color.red
						stopped = true
						points[points.size()-1] = points[points.size()-2]
						candie = false
					else:
						candie = true
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
