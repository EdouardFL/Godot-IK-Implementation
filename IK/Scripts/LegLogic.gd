extends Node2D

@export var step_target: Node2D
@export var step_distance: float = 5.0
@export var step_speed: float = 1.0
@export var step_height: float = 5.0
@export var overshoot_factor: float = 0.6
@export var IkSolver: Node2D
@export var AdjacentLegs: Array
@export var OppositeLegs: Array
@export var lerpfactor: float = 0 
var is_stepping = false
@onready var previous_pos = owner.global_position
@onready var goal_pos = step_target.global_position
signal step_initiated

func _process(delta):
	
	var can_step = true
	for legpath in AdjacentLegs:
		if get_node(legpath).is_stepping == true:
			can_step = false
			break
			
	if abs(IkSolver.goal_position.distance_to(step_target.global_position + (owner.global_position - previous_pos) * 1)) > step_distance && is_stepping == false && can_step:
		step()
		
		#if OppositeLegs:
			#for OppositeLeg in OppositeLegs:
				#get_node(OppositeLeg).step()
	
	var half_way = (IkSolver.goal_position + step_target.global_position)/2 - Vector2(0,step_height)
	var currentIkPos = IkSolver.goal_position
	
	var easedlerp = EaseInOutCubic(lerpfactor)
	IkSolver.goal_position = currentIkPos.lerp(half_way.lerp(goal_pos, easedlerp), easedlerp).lerp(half_way.lerp(goal_pos, easedlerp), easedlerp)
	lerpfactor += delta * step_speed
	
	if lerpfactor >= 1:
		is_stepping = false
	else:
		is_stepping = true
	
func step():
	
	step_initiated.emit()
	lerpfactor = 0
	goal_pos = step_target.global_position + (owner.global_position - previous_pos) * overshoot_factor
	previous_pos = owner.global_position
	
	#IkSolver.goal_position = Vector2.lerp(
	#	Vector2.lerp())
	#tween.tween_method(setIkSolverPos, IkSolver.goal_position, target_pos, 0.1)
	#tween.interpolate_value(IkSolver.goal_position, target_pos - IkSolver.goal_position, 0, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#IkSolver.goal_position = step_target.global_position
 
func EaseInOutCubic(x):
	return 1 / (1 + pow(2.71828, -10 * (x - 0.5)))

func setIkSolverPos(newPos):
	IkSolver.goal_position = newPos
