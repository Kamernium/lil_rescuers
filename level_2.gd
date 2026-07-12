extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$warp.area_entered.connect(warp)



func warp(_area):
	await get_tree().create_timer(0.01).timeout
	get_tree().change_scene_to_file("res://level_3.tscn")
