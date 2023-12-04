extends Node2D

@onready var leg_container = $LegContainer
@onready var signals = []
var ymodifier = 0
var tweening = false

func _ready():
	for i in leg_container.get_children():
		if i.has_signal("step_initiated"):
			i.step_initiated.connect(body_bob)
	
func _process(delta):
	var a_dir = Input.get_axis('ui_right', 'ui_left')
	translate(Vector2(-a_dir, 0) * 20 * delta )
	
	global_position.y += ymodifier
	
func body_bob():
	if tweening == true: return
	tweening = true
	var uptween = get_tree().create_tween()
	uptween.tween_property(self, "global_position:y", global_position.y + 2, 0.1)
	uptween.tween_callback(func(): 
		var downtween  = get_tree().create_tween()
		downtween.tween_property(self, "global_position:y", global_position.y - 2, 0.1)
		downtween.tween_callback(func():
			tweening = false
			)
		)
	
