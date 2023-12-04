extends Node2D

@export var Iterations: int = 32
@export var poletarget: Vector2 = Vector2(0,0)
@export var DrawDebug: bool = true
@export var DrawCircles: bool =  true
@export var DrawColor: Color = Color.WHITE
@export var DrawLineSize: float = 1.0

@onready var base_point = global_position
@export var limbs: Array = []
var joints = PackedVector2Array()
var limbs_size = 0
var goal_position = Vector2(0,0)

func update_ik(target: Vector2):
	for i in range(Iterations):
		_backward_pass(target)
		_foward_pass()

func _backward_pass(target: Vector2):
	joints[limbs_size] = target 
	for i in range(limbs_size, 0, -1):
		var a = joints[i]
		var b = joints[i - 1]
		var angle := a.angle_to_point(b)
		
		joints[i - 1] = a + Vector2(limbs[i - 1], 0).rotated(angle)
	
func _foward_pass():
	joints[0] = global_position
	for i in range(limbs_size):
		var a = joints[i]
		var b = joints[i + 1]
		var angle := a.angle_to_point(b)
		
		joints[i + 1] = a + Vector2(limbs[i], 0).rotated(angle)

func _rotate_to_pole():
	#var pole_point = to_local(joints[0] + poletarget)
	#var angle = to_local(joints[0]).angle_to_point(pole_point)
	#for i in range(joints.size()):
	#	if i > 0:
	#		joints[i] = to_global(to_local(joints[i]).rotated(angle))
			
	for i in range(joints.size()):
		if i > 0:
			var pole_point = (joints[i] + poletarget)
			var angle = (joints[i]).angle_to_point(pole_point)
			joints[i] = (joints[i]).rotated(angle)

func _ready():
	limbs_size = limbs.size()
	joints.resize(limbs_size + 1)
	joints[0] = global_position
	for i in range(limbs_size):
			joints[i+1] = joints[i] + Vector2(limbs[i], 0)

func _process(delta):
	_rotate_to_pole()
	#update_ik(get_global_mouse_position())
	update_ik(goal_position)
	if DrawDebug:
		queue_redraw()
		
func _draw():
	if not DrawDebug: return
	
	#draw_circle(to_local(joints[0] + poletarget), 3, Color.ORANGE)
	for i in range(limbs_size + 1):
		if i > 0:
			draw_line(to_local(joints[i - 1]), to_local(joints[i]), DrawColor, DrawLineSize)
			
	if DrawCircles:
		for i in range(limbs_size + 1):
			if i == 0:
				draw_circle(to_local(joints[i]), 3, Color.INDIAN_RED)
			elif i == limbs_size:
				draw_circle(to_local(joints[i]), 3, Color.PALE_GREEN)
			else:
				draw_circle(to_local(joints[i]), 3, Color.WHITE)
