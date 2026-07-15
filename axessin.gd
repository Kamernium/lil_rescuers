extends CharacterBody2D

enum State {SCANNING, THINKING, PROJECTILE, SLICE, LASER, DAMAGED}
var state : State = State.SCANNING : set = _set_state
var target : Area2D
var wait_time : float = 3.0
var selected_attack : int
var life_points : int = 150

@onready var progress_bar = $ProgressBar

var laser_sound = preload("res://bfxr_sounds/Laser1.wav")
var shoot_sfx = preload("res://bfxr_sounds/Powerup.wav")
var slice_sfx = preload("res://bfxr_sounds/Explosion2.wav")

var projectile = preload("res://axeprojectile.tscn")
var laser_scene = preload("res://laser.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$detect_player.area_entered.connect(player_entering)
	$weak_point.area_entered.connect(impact)
	$Timer.timeout.connect(wait_time_finish)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#$Label.text = str(life_points)
	progress_bar.value = life_points
	if life_points <= 100 and life_points >= 50:
		wait_time = 1.5
	elif life_points <= 50:
		wait_time = 0.7
	else:
		wait_time = 3.0
		
	match state:
		State.SCANNING:
			#Animación idle
			pass



func player_entering(area : Area2D):
	
	state = State.THINKING
	target = area
	



func impact(_area : Area2D):
	life_points -= 5
	#Animación de daño
	if  life_points <= 0:
		state = State.DAMAGED


func wait_time_finish():
	print(selected_attack)
	match selected_attack:
		1:
			state = State.PROJECTILE
		2:
			state = State.SLICE
		3:
			state = State.LASER

func end_of_attack():
	state = State.THINKING


func _set_state(new_state: State) -> void:
	state = new_state
	match state:
		State.THINKING:
			selected_attack = randi_range(1, 3)
			$Timer.start(wait_time)

		State.PROJECTILE:
			var projectile_instance = projectile.instantiate()
			projectile_instance.global_position = global_position
			get_tree().current_scene.add_child(projectile_instance)
			projectile_instance.target = target
			$AudioStreamPlayer2D.stream = shoot_sfx
			$AudioStreamPlayer2D.play()
			await get_tree().create_timer(0.2).timeout
			end_of_attack()

		State.SLICE:
			#Añadir animación antes del slice
			modulate.a = 0.5
			await get_tree().create_timer(0.2).timeout
			modulate.a = 1
			await get_tree().create_timer(0.2).timeout
			modulate.a = 0.5
			await get_tree().create_timer(0.2).timeout
			modulate.a = 1
			await get_tree().create_timer(0.2).timeout
			$AnimationPlayer.play("slice")
			$AudioStreamPlayer2D.stream = slice_sfx
			$AudioStreamPlayer2D.play()
			await get_tree().create_timer(0.2).timeout
			end_of_attack()

		State.LASER:
			var laser = laser_scene.instantiate()
			laser.global_position = global_position
			get_parent().add_child(laser)
			$AudioStreamPlayer2D.stream = laser_sound
			$AudioStreamPlayer2D.play()
			await get_tree().create_timer(laser.sweep_duration + 0.2).timeout
			end_of_attack()

		State.DAMAGED:
			#queue_free()
			$Axessin.visible = false
			$dead_sprite.visible = true
			await get_tree().create_timer(1.0).timeout
			get_tree().change_scene_to_file("res://ending.tscn")
