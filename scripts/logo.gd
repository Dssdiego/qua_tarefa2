extends KinematicBody2D

onready var ui_debug = get_parent().get_node("DebugUI")
onready var line2d = get_node("Line2D")

var colors = [Color.royalblue, Color.darkorange, Color.darkgreen, Color.darkmagenta, Color.orange, Color.cyan, Color.red]
var initial_speed = 5
var speed = 0
var can_move = false
var direction = Vector2(0,0)
var is_debug = false

# cálculo da colisão com os cantos da tela
func calc_screen_border_collision():
	var screen_size = get_viewport_rect().size # busca o tamanho da tela
	var collision_box = get_node("CollisionShape2D").get_shape().extents # calcula o tamanho da "caixa" de colisão
	
	# cálculo das "posições de impacto
	var collision_right = position.x + collision_box.x * 2
	var collision_left = position.x - collision_box.x * 2
	var collision_down = position.y + collision_box.y * 2
	var collision_up = position.y - collision_box.y * 2
	
	# check de colisão da direita
	if collision_right > screen_size.x: # 'Passou' da parte direita, reflete para esquerda
		direction.x *= -1
		change_color()
	
	# check de colisão da esquerda
	if collision_left < 0: # 'Passou' da parte esquerda, reflete para direita
#		print('Passou da esquerda')
		direction.x *= 1
		change_color()
	
	# check de colisão de baixo
	if collision_down > screen_size.y: # 'Passou' da parte de baixo, reflete para cima
		direction.y *= -1
		change_color()
		
	# check de colisão de cima
	if collision_up < 0: # 'Passou' da parte de cima, reflete para baixo
		direction.y *= -1
		change_color()

# mudança de cor do logo
func change_color():
	var color: Color = colors[randi() % colors.size()]
	get_node("Sprite").modulate = color
	
	randomize()
	colors.shuffle()

# posiciona logo no centro da tela
func position_ball_at_center():
	var screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x/2, screen_size.y/2)

# desenha linha de debug (direção)
func draw_debug_line(target: Vector2):
	var multp = 20
	line2d.points = [Vector2(0,0), Vector2(target.x * multp, target.y * multp)]
	line2d.default_color = Color.red
	line2d.width = 4

# update - loop de atualização do "jogo"
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
	
	if Input.is_action_just_pressed("debug"):
		is_debug = !is_debug
	
	if is_debug:
		draw_debug_line(Vector2(direction.x, direction.y))
	else:
		line2d.clear_points()

# update do motor de física
func _physics_process(delta):
	position += direction.normalized() * speed
