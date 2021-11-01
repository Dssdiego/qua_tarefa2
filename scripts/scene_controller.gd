extends Node

func take_screenshot(scene_name):
	var capture = get_viewport().get_texture().get_data()
	capture.flip_y()
	capture.save_png("res://export/" + scene_name + ".png")

func go_to_scene(number):
	if number == 1:
		get_tree().change_scene("res://scenes/header.tscn")
		
	if number == 2:
		get_tree().change_scene("res://scenes/main.tscn")
		
	if number == 3:
		get_tree().change_scene("res://scenes/slide.tscn")
		
	if number == 4:
		get_tree().change_scene("res://scenes/citations.tscn")

func export_pdf():
	go_to_scene(1) # header
	yield(get_tree().create_timer(.5), "timeout")
	take_screenshot("1")
	
	go_to_scene(2) # game
	yield(get_tree().create_timer(3), "timeout")
	take_screenshot("2")
	
	go_to_scene(3) # comparison <> attributes
	yield(get_tree().create_timer(.5), "timeout")
	take_screenshot("3")
	
	go_to_scene(4) # references
	yield(get_tree().create_timer(.5), "timeout")
	take_screenshot("4")
	
	print('slides (png) exported successfully!')

func _process(delta):
	if Input.is_action_just_pressed("scene_1"):
		go_to_scene(1)
		
	if Input.is_action_just_pressed("scene_2"):
		go_to_scene(2)
	
	if Input.is_action_just_pressed("scene_3"):
		go_to_scene(3)
	
	if Input.is_action_just_pressed("scene_4"):
		go_to_scene(4)
		
	if Input.is_action_just_pressed("screenshot"):
		take_screenshot("screenshot")
		
	if Input.is_action_just_pressed("export"):
		export_pdf()
