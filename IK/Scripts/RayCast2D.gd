extends RayCast2D

@export var step_target: Marker2D

func _physics_process(delta):
	var hit_point = get_collision_point()
	if is_colliding():
		step_target.global_position = hit_point
