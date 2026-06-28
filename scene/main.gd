extends Control

@export var General:TabContainer
@export	var generate_button:Button
@export var save_button: Button
@export var save_file_dialog: FileDialog
@export var texture_rect: TextureRect
@export var area_2d: Area2D

func _ready() -> void:
	save_button.pressed.connect(save_picture)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_hide"):
		General.visible = !General.visible

#region Picture saving code
func save_picture():	
	save_file_dialog.popup_centered() 

func _on_save_file_dialog_file_selected(path: String) -> void:
	General.visible = !General.visible
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
	General.visible = !General.visible
#endregion 
	
