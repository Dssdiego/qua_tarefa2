extends Node2D

onready var label_direction = get_node("Logo Direction")
onready var label_speed = get_node("Logo Speed")

export var show_debug = false

# atualiza o HUD
func update_hud(direction, speed):
	label_direction.text = "(" + str(direction.x) + " , " + str(direction.y) + ")"
	label_speed.text = str(speed)

func _process(delta):
	if !show_debug:
		self.hide()
	
	if show_debug:
		self.show()
		
	if Input.is_action_just_pressed("debug"):
		show_debug = !show_debug

