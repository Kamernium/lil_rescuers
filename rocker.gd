extends CharacterBody2D

@export var speed : float = 550.5
var target : Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$detectplayer.area_entered.connect(player_entered)
	$detectplayer.area_exited.connect(player_exited)
	$"Areadaño".area_entered.connect(received_attack)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if target != null:
		position.x -= speed * delta
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.stop()
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()


func player_entered(area):
	
	target = area


func player_exited(_area):
	target = null


func received_attack(_area):
	#Animación de daño
	await get_tree().create_timer(0.01).timeout
	queue_free()
