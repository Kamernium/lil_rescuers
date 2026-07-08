extends CharacterBody2D

var lives = 3

enum State { IDLE, TRACKING, FALLING, LANDED }
var state: State = State.IDLE
var target: Node = null
var fall_speed: float = 2300.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$detectplayer.area_entered.connect(player_attack)
	$"Areadaño".area_entered.connect(impact)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#Cambiar de color dependiendo de cuantos golpes ha recibido
	match state:
		State.TRACKING:
			global_position.x = target.global_position.x
		State.FALLING:
			velocity.y = fall_speed
			move_and_slide()
			if is_on_floor():
				land()
		State.LANDED:
			velocity = Vector2.ZERO # se queda quieto mientras "descansa"


func player_attack(area : Area2D):
	if state != State.IDLE:
		return # evita reiniciar el ataque si ya está en curso
	target = area
	global_position.y -= 500
	state = State.TRACKING
	await get_tree().create_timer(1.0).timeout
	state = State.FALLING

func land() -> void:
	state = State.LANDED # cambia de estado INMEDIATAMENTE para no reentrar
	velocity = Vector2.ZERO
	# aquí podrías añadir daño en área, shake de cámara, animación de impacto, etc.
	await get_tree().create_timer(0.9).timeout
	global_position.y -= 500 
	state = State.TRACKING
	await get_tree().create_timer(1.0).timeout
	state = State.FALLING
	

func impact(area : Area2D):
	if lives <= 0:
		queue_free()
	else:
		if area.is_in_group("projectiles"):
			lives -= 1
		else:
			return
