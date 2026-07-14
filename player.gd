extends CharacterBody2D

var lilguys: int = 15
var can_get_hurt: bool = true
var can_shoot : bool = true
var bossmode : bool = false
signal boss_signal
var projectile = preload("res://lilguy.tscn")
var jump_sound_effect = preload("res://bfxr_sounds/Jump.wav")
var lilguy_sfx = preload("res://lilguy.ogg")
var danio_sfx = preload("res://damaged_sound.wav")
@onready var music = $Music
@onready var sfx = $SFX


@onready var current_scene = load(get_parent().scene_file_path)


const SPEED = 900.0
const JUMP_VELOCITY = -750.0


func _ready() -> void:
	$"Areadaño".area_entered.connect(recibir_impacto)
	$"Areadaño".body_entered.connect(recibir_impacto)
	$bossmodeactivator.area_entered.connect(boss_mode)
	$intakill.area_entered.connect(out_of_bounds)
	$CanvasLayer/Button.pressed.connect(despausar)

func _physics_process(delta: float) -> void:
	if lilguys < 1:
		death() 
	$CanvasLayer/Label.text = str(lilguys)
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sfx.stream = jump_sound_effect
		sfx.play()
	
	if can_shoot:
		if Input.is_action_pressed("attack"):
			$Flechader.visible = true
		else:
			$Flechader.visible = false
	else:
		return
	
	
	if Input.is_action_pressed("ui_left"):
		position.x -= SPEED * delta
		
	elif Input.is_action_pressed("ui_right"):
		position.x += SPEED * delta
		
	
	if Input.is_action_just_released("attack"):
		if can_shoot:
			attack_process()
		else:
			return
	
	if Input.is_action_just_pressed("pausar"):
		get_tree().paused = true
	
	if get_tree().paused:
		$CanvasLayer/Label2.visible = true
		$CanvasLayer/Button.visible = true
	else:
		$CanvasLayer/Label2.visible = false
		$CanvasLayer/Button.visible = false
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()



func death():
	#print("MUERTE")
	
	GlobalManager.last_played_zone = current_scene
	await get_tree().create_timer(0.01).timeout
	get_tree().change_scene_to_file("res://deathscreen.tscn")
	

func lilguy_recovery(timeout : float,lostguys : int):
	await get_tree().create_timer(timeout).timeout
	#Animacion de retirada
	lilguys += lostguys


func attack_process():
	lilguys -= 1
	sfx.stream = lilguy_sfx
	sfx.play()
	var lilguylaunch = projectile.instantiate()
	lilguylaunch.global_position = self.global_position
	get_tree().current_scene.add_child(lilguylaunch)
	lilguy_recovery(7.0,1)
	can_shoot = false
	await get_tree().create_timer(0.13).timeout
	can_shoot = true




func recibir_impacto(_area):
	if can_get_hurt:
		lilguys -= 5
		sfx.stream = danio_sfx
		sfx.play()
		lilguy_recovery(10.5,5)
		damage_cooldown()
		#Y reproducir animación de daño
	else:
		return

func damage_cooldown():
	#var cooldown_anim = get_tree().create_tween()
	can_get_hurt = false
	#animación tween
	$Player_spr.modulate.a = 0.5
	for i in range(5):
		$Player_spr.visible = false
		await get_tree().create_timer(0.3).timeout
		$Player_spr.visible = true
		await get_tree().create_timer(0.3).timeout
		#cooldown_anim.tween_property($Icon,"visible",false,0.3)
		#cooldown_anim.tween_property($Icon,"visible",true,0.3)
	
	await get_tree().create_timer(3.0).timeout
	$Player_spr.modulate.a = 1
	can_get_hurt = true


func boss_mode(_area : Area2D):
	var zoom_out = get_tree().create_tween()
	zoom_out.tween_property($Camera2D,"zoom",Vector2(0.3,0.3),1.0)
	bossmode = true
	boss_signal.emit()
	print("estoy en un jefe.")
	
	
	



func out_of_bounds(_area):
	death()


func despausar():
	get_tree().paused = false
