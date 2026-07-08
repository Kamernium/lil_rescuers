extends CharacterBody2D

var lilguys: int = 15
var can_get_hurt: bool = true
var can_shoot : bool = true
var projectile = preload("res://lilguy.tscn")

@onready var current_scene = load(get_parent().scene_file_path)


const SPEED = 900.0
const JUMP_VELOCITY = -550.0


func _ready() -> void:
	$"Areadaño".area_entered.connect(recibir_impacto)

func _physics_process(delta: float) -> void:
	if lilguys < 1:
		death() 
	$Label.text = str(lilguys)
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
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
	
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()



func death():
	#print("MUERTE")
	GlobalManager.last_played_zone = current_scene
	
	get_tree().change_scene_to_file("res://deathscreen.tscn")

func lilguy_recovery(timeout : float,lostguys : int):
	await get_tree().create_timer(timeout).timeout
	#Animacion de retirada
	lilguys += lostguys


func attack_process():
	lilguys -= 1
	var lilguylaunch = projectile.instantiate()
	lilguylaunch.global_position = self.global_position
	get_tree().current_scene.add_child(lilguylaunch)
	lilguy_recovery(7.0,1)
	can_shoot = false
	await get_tree().create_timer(0.2).timeout
	can_shoot = true




func recibir_impacto(_area):
	if can_get_hurt:
		lilguys -= 5
		lilguy_recovery(10.5,5)
		damage_cooldown()
		#Y reproducir animación de daño
	else:
		return

func damage_cooldown():
	#var cooldown_anim = get_tree().create_tween()
	can_get_hurt = false
	#animación tween
	$Icon.modulate.a = 0.5
	for i in range(5):
		$Icon.visible = false
		await get_tree().create_timer(0.3).timeout
		$Icon.visible = true
		await get_tree().create_timer(0.3).timeout
		#cooldown_anim.tween_property($Icon,"visible",false,0.3)
		#cooldown_anim.tween_property($Icon,"visible",true,0.3)
	
	await get_tree().create_timer(3.0).timeout
	$Icon.modulate.a = 1
	can_get_hurt = true
