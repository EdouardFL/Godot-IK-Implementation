extends Node2D

@onready var IkSolver = $IkSolver

func _process(delta):
	IkSolver.goal_position = get_global_mouse_position()
