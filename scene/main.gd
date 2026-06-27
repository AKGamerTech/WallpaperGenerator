extends Control

@export var Configs:TabContainer
@export	var generate_button:Button
@export var save_button: Button
@export var save_file_dialog: FileDialog
@export var texture_rect: TextureRect
@export var area_2d: Area2D

@export var background: TextureRect

@export var shapes_color_picker: ColorPickerButton
@export var shapes_color_pickerA: ColorPickerButton
@export var shapes_color_pickerB: ColorPickerButton
@export var shapes_color_pickerC: ColorPickerButton
@export var shapes_color_pickerD: ColorPickerButton

@export var amount_label: Label
@export var amount_slider: HSlider
@export var min_size_slider: Slider
@export var min_size_label: Label
@export var max_size_slider: Slider
@export var max_size_label: Label

@export var random_color_box: CheckBox
@export var random_type: OptionButton
@export var random_data: RichTextLabel

 
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_hide"):
		Configs.visible = !Configs.visible

func _ready():
	amount_slider.value_changed.connect(update_amount)
	max_size_slider.value_changed.connect(update_max)
	min_size_slider.value_changed.connect(update_min)

	generate_button.pressed.connect(spawn)
	save_button.pressed.connect(save_picture)
	
	area_2d.body_exited.connect(throwitback)
	
func update_amount(label_data):
	amount_label.text = "Amount: " + str(label_data)
	
func update_min(label_data):
	min_size_label.text = "Min Size: " + str(label_data)
	
func update_max(label_data):
	max_size_label.text = "Max Size: " + str(label_data)

#region Spawner code
func spawn():
	var random_color = Color(randf(), randf(), randf())
	for each in texture_rect.get_children():
		each.queue_free()
		random_data.text = ""
	for each in amount_slider.value:
		var object: RigidBody2D = preload("res://scene/heart.tscn").instantiate()
		object.position = Vector2(randf_range(0, 1920), randf_range(0,1080))
		var object_sprite: Sprite2D = object.find_child("Sprite2D")
		var object_collision: CollisionPolygon2D = object.find_child("CollisionPolygon2D")
		var random_size: float = randf_range(min_size_slider.value,max_size_slider.value)
		object_sprite.scale = Vector2.ONE * random_size
		object_collision.scale = Vector2.ONE * random_size
		object.rotation_degrees = randf() * 360.0
		if !random_color_box.button_pressed:
			object_sprite.modulate = shapes_color_picker.color
			random_data.text = random_data.text + " \n Shape: \n" + str(shapes_color_picker.color)
		else:
			if random_type.selected == 0 :
				var temp_color:= Color(randf(), randf(), randf())
				object_sprite.modulate = temp_color 
				random_data.text = random_data.text + " \n Shape: \n" + str(temp_color)
			else:
				random_data.text = random_data.text + " \n Shape: \n" + str(random_color)
				object_sprite.modulate = random_color
		texture_rect.add_child(object)

func throwitback(body: PhysicsBody2D):
	body.position = Vector2(randf_range(0, 1920), randf_range(0,1080))
#endregion 

#region Picture saving code
func save_picture():	
	save_file_dialog.popup_centered() 

func _on_save_file_dialog_file_selected(path: String) -> void:
	Configs.visible = !Configs.visible
	print(path)
	# Wait until the frame has finished before getting the texture.
	await RenderingServer.frame_post_draw
	# Get the viewport image.
	var img = get_viewport().get_texture().get_image()
	## Crop the image so we only have canvas area.
	#var cropped_image = img.get_region(Vector2(drawing_area.position, drawing_area.size))
	# Save the image with the passed in path we got from the save dialog.
	if path.contains(".png"):
			img.save_png(path)
	elif path.contains(".jpg") or path.contains(".jpeg"):
			img.save_jpg(path)
	else :
			img.save_png(path + ".png")
	Configs.visible = !Configs.visible
#endregion 
	
