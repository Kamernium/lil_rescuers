extends CharacterBody2D

@export var speed : float = 100.0
var target : Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#AVISO: LA COLISIÓN DE DETECCIÓN DE DAÑO SE ENCUENTRA EN LAYER 2
	$detectplayer.area_entered.connect(player_entered)
	$detectplayer.area_exited.connect(player_exited)
	$"Areadaño".area_entered.connect(received_attack)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if target != null:
		position.x -= speed * delta
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()


func player_entered(area):
	
	target = area


func player_exited(_area):
	target = null


func received_attack(_area):
	#Animación de daño
	queue_free()
