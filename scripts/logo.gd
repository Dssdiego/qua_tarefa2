extends KinematicBody2D

onready var ui_debug = get_parent().get_node("DebugUI")

var last_idx
var colors = [Color.royalblue, Color.darkorange, Color.darkgreen, Color.darkmagenta, Color.orange, Color.cyan, Color.red]
var initial_speed = 5
var speed = 0
var can_move = false
var direction = Vector2(0,0)

func _ready():
	pass # Replace with function body.

func calc_screen_border_collision():
	var screen_size = get_viewport_rect().size
	var collision_box = get_node("CollisionShape2D").get_shape().extents
	
	var collision_right = position.x + collision_box.x * 2
	var collision_left = position.x - collision_box.x * 2
	var collision_down = position.y + collision_box.y * 2
	var collision_up = position.y - collision_box.y * 2
	
	if collision_right > screen_size.x: # 'Passou' da parte direita, reflete para esquerda
		direction.x *= -1
		change_color()
	
	if collision_left < 0: # 'Passou' da parte esquerda, reflete para direita
#		print('Passou da esquerda')
		direction.x *= 1
		change_color()
	
	if collision_down > screen_size.y: # 'Passou' da parte de baixo, reflete para cima
		direction.y *= -1
		change_color()
		
	if collision_up < 0: # 'Passou' da parte de cima, reflete para baixo
		direction.y *= -1
		change_color()

func change_color():
	var color: Color = colors[randi() % colors.size()]
	get_node("Sprite").modulate = color
	
	randomize()
	colors.shuffle()

func position_ball_at_center():
	var screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x/2, screen_size.y/2)

func _process(delta):
	if Input.is_action_just_pressed("play_ball"):
		position_ball_at_center()
		change_color()
		speed = initial_speed
		can_move = true
		direction = Vector2(1,1)
		
	if Input.is_action_just_pressed("increase_speed"):
		speed += 1
	
	if Input.is_action_just_pressed("decrease_speed"):
		speed -= 1
		
	if Input.is_action_just_pressed("reset_speed"):
		speed = initial_speed
	
	if can_move:
		ui_debug.update_hud(direction, speed)
		calc_screen_border_collision()

func _physics_process(delta):
	position += direction.normalized() * speed
