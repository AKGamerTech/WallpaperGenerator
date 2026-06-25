extends Control

@export var Configs:TabContainer
@export	var generate_button:Button
@export var save_button: Button
@export var save_file_dialog: FileDialog
@export var texture_rect: TextureRect
@export var area_2d: Area2D

@export var background: TextureRect

@export var shapes_color_picker: ColorPickerButton
@export var amount_label: Label
@export var amount_slider: HSlider

@export var random_color_box: CheckBox
@export var random_type: OptionButton
@export var random_data: RichTextLabel

@export var index: int
@export var gradient_data: Dictionary[float, Color]
 
@export var bg_color_amount: OptionButton
@export var bg_color_picker: ColorPickerButton
@export var bg_color_picker_a: ColorPickerButton
@export var bg_color_picker_b: ColorPickerButton
@export var bg_color_picker_c: ColorPickerButton
@export var bg_color_picker_d: ColorPickerButton


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_hide"):
		Configs.visible = !Configs.visible

func _ready():
	amount_slider.value_changed.connect(update_amount)
	generate_button.pressed.connect(spawn)
	save_button.pressed.connect(save_picture)
	
	area_2d.body_exited.connect(throwitback)
	
	bg_color_amount.item_selected.connect(refresh_color_selectors.unbind(1))
	bg_color_picker.popup_closed.connect(refresh_color_selectors)
	bg_color_picker_a.popup_closed.connect(refresh_color_selectors)
	bg_color_picker_b.popup_closed.connect(refresh_color_selectors)
	bg_color_picker_c.popup_closed.connect(refresh_color_selectors)
	bg_color_picker_d.popup_closed.connect(refresh_color_selectors)

func update_amount(label_data):
	amount_label.text = "Amount: " + str(label_data)

func refresh_color_selectors() -> void:
	var index_bg = bg_color_amount.selected
	match index_bg:
		0:
			print(index_bg)
			bg_color_picker.visible = true
			bg_color_picker_a.visible = false
			bg_color_picker_b.visible = false
			bg_color_picker_c.visible = false
			bg_color_picker_d.visible = false
			gradient_data = {
				0.0: bg_color_picker.color
			}
			set_gradient()
		1:
			print(index_bg)
			bg_color_picker.visible = false
			bg_color_picker_a.visible = true
			bg_color_picker_b.visible = true
			bg_color_picker_c.visible = false
			bg_color_picker_d.visible = false
			gradient_data = {
				0.0: bg_color_picker_a.color,
				1.0: bg_color_picker_d.color,
			}
			set_gradient()
		2:
			print(index_bg)
			bg_color_picker.visible = false
			bg_color_picker_a.visible = true
			bg_color_picker_b.visible = true
			bg_color_picker_c.visible = true
			bg_color_picker_d.visible = false
			gradient_data = {
				0.0: bg_color_picker_a.color,
				0.5: bg_color_picker_b.color,
				1.0: bg_color_picker_d.color,
			}
			set_gradient()
		3:
			print(index_bg)
			bg_color_picker.visible = false
			bg_color_picker_a.visible = true
			bg_color_picker_b.visible = true
			bg_color_picker_c.visible = true
			bg_color_picker_d.visible = true
			gradient_data = {
				0.0: bg_color_picker_a.color,
				0.30: bg_color_picker_b.color,
				0.70: bg_color_picker_c.color,
				1.0: bg_color_picker_d.color,
			}
			set_gradient()
			

#region BG Gradient
func set_gradient():

	var gradient := Gradient.new()
	gradient.offsets = gradient_data.keys()
	gradient.colors = gradient_data.values()
	
	var gradient_texture := GradientTexture2D.new()
	gradient_texture.width = 1920
	gradient_texture.height = 1080
	gradient_texture.gradient = gradient

	background.texture = gradient_texture
#endregion 

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
		var random_size: float = randf_range(0.1,1)
		object_sprite.scale = Vector2.ONE * random_size
		object_collision.scale = Vector2.ONE * random_size
		object.rotation_degrees = randf() * 360.0
		if !random_color_box.button_pressed:
			object_sprite.modulate = shapes_color_picker.color
			random_data.text = random_data.text + " \n Shape: \n" + str(shapes_color_picker.color)
		else:
			gradient_data = {
				0.0: Color(randf(), randf(), randf())
			}
			set_gradient()
			if random_type.selected == 0 :
				var temp_color:= Color(randf(), randf(), randf())
				object_sprite.modulate = temp_color 
				random_data.text = random_data.text + " \n Shape: \n" + str(temp_color)
			else:
				random_data.text = random_data.text + " \n Shape: \n" + str(random_color)
				object_sprite.modulate = random_color
		texture_rect.add_child(object)
	random_data.text = random_data.text + " \n BGColor: \n" + str(gradient_data.get(0.0))

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
	
