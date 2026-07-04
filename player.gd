extends CharacterBody2D

var lilguys: int = 15

@onready var current_scene = load(get_parent().scene_file_path)


const SPEED = 900.0
const JUMP_VELOCITY = -550.0


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if lilguys < 1:
		death() 
	$Label.text = str(lilguys)
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("attack"):
		$Flechader.visible = true
	else:
		$Flechader.visible = false
	
	
	if Input.is_action_pressed("ui_left"):
		position.x -= SPEED * delta
		
	elif Input.is_action_pressed("ui_right"):
		position.x += SPEED * delta
		
	
	if Input.is_action_just_released("attack"):
		attack_process()
	
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

func attack_process():
	lilguys -= 1
	#Aquí iría todo lo que es instanciar una criatura
	#hacia la dirección seleccionada y que haga daño al enemigo
	#al colisionar
	await get_tree().create_timer(7.0).timeout
	#Animacion de retirada
	lilguys += 1
