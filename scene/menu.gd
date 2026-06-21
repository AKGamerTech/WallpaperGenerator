extends Control
@export var start_button: Button

@export var settings_button: Button
@export var background_settings: ColorRect
@export var exit_settings: Button

@export var about_button: Button
@export var exit_button: Button

func _ready():
	start_button.pressed.connect(start)
	settings_button.pressed.connect(settings)
	exit_settings.pressed.connect(settings_exit)
	about_button.pressed.connect(about)
	exit_button.pressed.connect(exit)
	
func start() :
	get_tree().change_scene_to_file("res://scene/main.tscn")

func settings():
	background_settings.visible = !background_settings.visible
	
func settings_exit():
	background_settings.visible = !background_settings.visible

func about():
	pass
	
func exit():
	get_tree().quit()
