extends Control

@export var Configs:Panel
@export	var generate_button:Button
@export var save_button: Button
@export var save_file_dialog: FileDialog
@export var texture_rect: TextureRect
@export var area_2d: Area2D

@export var background: TextureRect


@export var heart_color_picker: ColorPickerButton
@export var bg_color_picker_A: ColorPickerButton
@export var bg_color_picker_B: ColorPickerButton
@export var random_color_box: CheckBox
@export var random_type: OptionButton


@export var amount_label: Label
@export var amount_slider: HSlider

@export var index: int

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_hide"):
		Configs.visible = !Configs.visible

func _ready():
	generate_button.pressed.connect(spawn)
	save_button.pressed.connect(save_picture)
	area_2d.body_exited.connect(throwitback)

func _on_h_slider_value_changed(value: float) -> void:
	amount_label.text = "Amount " + str(amount_slider.value)

#region Spawner code
func spawn():
	var random_color = Color(randf(), randf(), randf())
	for each in texture_rect.get_children():
		each.queue_free()
	for each in amount_slider.value:
		var object: RigidBody2D = preload("res://scene/heart.tscn").instantiate()
		object.position = Vector2(randf_range(0, 1920), randf_range(0,1080))
		var object_sprite: Sprite2D = object.find_child("Sprite2D")
		var object_collision: CollisionPolygon2D = object.find_child("CollisionPolygon2D")
		var random_size: float = randf_range(0.1,1)
		object_sprite.scale = Vector2.ONE * random_size
		object_collision.scale = Vector2.ONE * random_size
		object.rotation_degrees = randf() * 360.0
		if !random_color_box.button_pressed:
			background.modulate = bg_color_picker_A.color
			object_sprite.modulate = heart_color_picker.color
		else:
			background.modulate = Color(randf(), randf(), randf())
			if random_type.selected == 0 :
				object_sprite.modulate = Color(randf(), randf(), randf())
			else:
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
	
