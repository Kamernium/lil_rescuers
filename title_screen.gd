extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Agregar cómic al abrir el juego.
	$Button.pressed.connect(btn_pressed)
	$AudioStreamPlayer.play(5.3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Comic.visible:
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("attack"):
			$Comic.visible = false
	
	

func btn_pressed():
		get_tree().change_scene_to_file("res://level_1.tscn")
