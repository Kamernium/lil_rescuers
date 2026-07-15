extends Node2D

var boss_buildup = load("res://Boss_buildup.ogg")
var boss_battle = load("res://Boss_battle.ogg")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.music.stream = boss_buildup
	$Player.music.play()
	$Player.boss_signal.connect(boss_music)
	$scene_transition/CanvasLayer/AnimationPlayer.play("fade_in")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Player.bossmode:
		$StaticBody2D.visible = true
		$StaticBody2D/CollisionShape2D.disabled = false
		
		

func boss_music():
	if $Player.music.stream != boss_battle:
		$Player.music.stream = boss_battle
	else:
		return
	$Player.music.play()
