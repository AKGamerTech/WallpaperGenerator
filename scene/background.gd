extends VBoxContainer
@export var background: TextureRect
@export var main: Control

@export var bg_color_amount: OptionButton
@export var bg_color_picker: ColorPickerButton
@export var bg_color_picker_a: ColorPickerButton
@export var bg_color_picker_b: ColorPickerButton
@export var bg_color_picker_c: ColorPickerButton
@export var bg_color_picker_d: ColorPickerButton

@export var random_color_box: CheckBox
@export var bg_data: RichTextLabel
@export var generate_button: Button
@export var gradient_data: Dictionary[float, Color] = {0.0:Color(0.737, 0.737, 0.737)}



func _ready():
	bg_color_amount.item_selected.connect(refresh_color_selectors.unbind(1))
	bg_color_picker.popup_closed.connect(refresh_color_selectors)
	bg_color_picker_a.popup_closed.connect(refresh_color_selectors)
	bg_color_picker_b.popup_closed.connect(refresh_color_selectors)
	bg_color_picker_c.popup_closed.connect(refresh_color_selectors)
	bg_color_picker_d.popup_closed.connect(refresh_color_selectors)
	
	generate_button.pressed.connect(spawn)

#region BG Color Selectors
func refresh_color_selectors():
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

func spawn():
	if !random_color_box.button_pressed:
		bg_data.text = "BGColor: \n" + str(gradient_data.values())
	else:
		pass
		#gradient_data = {
			#0.0: Color(randf(), randf(), randf())
		#}
		#set_gradient()
		#bg_data.text = "BGColor: \n" + str(gradient_data.values())
