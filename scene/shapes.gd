extends VBoxContainer

@export var spawn_area: TextureRect
@export var box_trap: Area2D



@export var shapes_color_picker: ColorPickerButton
@export var shapes_color_pickerA: ColorPickerButton
@export var shapes_color_pickerB: ColorPickerButton
@export var shapes_color_pickerC: ColorPickerButton
@export var shapes_color_pickerD: ColorPickerButton

@export var shapes_array: Array
@onready var heart_button: TextureButton = $ShapesButtons/Heart
@onready var plus_button: TextureButton = $ShapesButtons/Plus
@onready var square_button: TextureButton = $ShapesButtons/Square
const HEART = preload("res://shape/heart.tscn")
const PLUS = preload("res://shape/plus.tscn")
const SQUARE = preload("uid://dh4shpbmjon1p")


@export var amount_label: Label
@export var amount_slider: HSlider
@export var min_size_label: Label
@export var min_size_slider: Slider
@export var max_size_label: Label
@export var max_size_slider: Slider

@export var shape_random_color: CheckBox
@export var shape_random_type: OptionButton
@export var shape_random_data: RichTextLabel

@export	var generate_button:Button
@export	var more_button:Button

@export var random_color: Color

@export var orange_colors: Dictionary[int, Color]
@export var orange_colors_amount: int

@export var green_colors: Dictionary[int, Color]
@export var green_colors_amount: int

@export var temp_color: Color

@export var horizontal_rez: TextEdit
@export var vertical_rez: TextEdit

func _ready():
	amount_slider.value_changed.connect(update_amount)
	max_size_slider.value_changed.connect(update_max)
	min_size_slider.value_changed.connect(update_min)

	generate_button.pressed.connect(clear)
	more_button.pressed.connect(spawn)
	
	box_trap.body_exited.connect(throwitback)
	load_orange()
	load_green()
	
func load_orange():
	var file_orange = FileAccess.open("res://colors/orange_colors.txt", FileAccess.READ)
	var txt_line = int(1)
	while not file_orange.eof_reached():
		var tmp = file_orange.get_line()
		if tmp == "":
			break
		orange_colors.get_or_add(txt_line, tmp)
		orange_colors_amount = txt_line
		#remember assign this first then add 1 othewise you'll run into the null error where the total amount is more than there is 
		txt_line = txt_line + 1 

func load_green():
	var file_green = FileAccess.open("res://colors/green_colors.txt", FileAccess.READ)
	var txt_line = int(1)
	while not file_green.eof_reached():
		var tmp = file_green.get_line()
		if tmp != str(""):
			green_colors.get_or_add(txt_line, tmp)
			green_colors_amount = txt_line
			#remember assign this first then add 1 othewise you'll run into the null error where the total amount is more than there is 
			txt_line = txt_line + 1
		else:
			break


func update_amount(label_data):
	amount_label.text = "Amount: " + str(label_data)
	
func update_min(label_data):
	min_size_label.text = "Min Size: " + str(label_data)
	
func update_max(label_data):
	max_size_label.text = "Max Size: " + str(label_data)

func sleep(seconds: float)->void:
	await get_tree().create_timer(seconds).timeout

func clear():
	random_color = Color(randf(), randf(), randf())
	for each in spawn_area.get_children():
		each.queue_free()
		shape_random_data.text = ""
	spawn()

#region Spawner code
func spawn():
	shapes_array.clear()
	for each in amount_slider.value:
		if heart_button.button_pressed:
			shapes_array.append(HEART) 
		if plus_button.button_pressed:
			shapes_array.append(PLUS)
		if square_button.button_pressed:
			shapes_array.append(SQUARE)
		var tscn_path = shapes_array.pick_random()
		var object: RigidBody2D = (tscn_path).instantiate()
		object.position = Vector2(randf_range(0, float(horizontal_rez.text)), randf_range(0, float(vertical_rez.text)))
		var object_sprite: Sprite2D = object.find_child("Sprite2D")
		var object_collision: CollisionPolygon2D = object.find_child("CollisionPolygon2D")
		var random_size: float = randf_range(min_size_slider.value,max_size_slider.value)
		object_sprite.scale = Vector2.ONE * random_size
		object_collision.scale = Vector2.ONE * random_size
		object.rotation_degrees = randf() * 360.0
		if !shape_random_color.button_pressed:
			object_sprite.modulate = shapes_color_picker.color
			shape_random_data.text = shape_random_data.text + " \n Shape: \n" + str(shapes_color_picker.color)
		else:
			if shape_random_type.selected == 0 :
				temp_color = Color(randf(), randf(), randf())
				object_sprite.modulate = temp_color 
				shape_random_data.text = shape_random_data.text + " \n Shape: \n" + str(temp_color)
			if shape_random_type.selected == 1:
				shape_random_data.text = shape_random_data.text + " \n Shape: \n" + str(random_color)
				object_sprite.modulate = random_color
			if shape_random_type.selected == 2:
				var color_or_gr:= randi_range(0,1)
				if color_or_gr == 0:
					temp_color = orange_colors.get(randi_range(1, orange_colors_amount))
					object_sprite.modulate = temp_color
				else:
					temp_color = green_colors.get(randi_range(1, green_colors_amount))
					object_sprite.modulate = temp_color
		spawn_area.add_child(object)
		await sleep(0.1)

func throwitback(body: PhysicsBody2D):
	body.position = Vector2(randf_range(0, 1920), randf_range(0,1080))
#endregion 
