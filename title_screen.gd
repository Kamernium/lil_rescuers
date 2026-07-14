extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Agregar cómic al abrir el juego.
	$Button.pressed.connect(btn_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	

func btn_pressed():
		get_tree().change_scene_to_file("res://level_1.tscn")
