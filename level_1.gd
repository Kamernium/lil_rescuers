extends Node2D

var music = load("res://level1_song.ogg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$warp.area_entered.connect(warp)
	$Player.music.stream = music
	$Player.music.play()
	$scene_transition/CanvasLayer/AnimationPlayer.play("fade_in")



func warp(_area):
	$scene_transition/CanvasLayer/AnimationPlayer.play_backwards("fade_in")
	#await get_tree().create_timer(0.01).timeout
	await $scene_transition/CanvasLayer/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://level_2.tscn")
