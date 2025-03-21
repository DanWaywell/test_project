extends Camera3D

@export var node_to_track: Node3D
@export var distance_before_follow = 1.0

func _process(_delta: float) -> void:
	if node_to_track == null:
		pass
	else:
		if node_to_track.global_position.x > global_position.x + distance_before_follow:
			global_position.x = node_to_track.global_position.x - distance_before_follow
		elif node_to_track.global_position.x < global_position.x - distance_before_follow:
			global_position.x = node_to_track.global_position.x + distance_before_follow
			
	
