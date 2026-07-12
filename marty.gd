extends CharacterBody2D

var can_hurt : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Areadaño".area_entered.connect(collision)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	move_and_slide()


func collision(area : Area2D):
	if area.is_in_group("projectiles"):
		if !can_hurt:
			#Animación bloqueando ataque
			can_hurt = true
			await get_tree().create_timer(0.4).timeout
			can_hurt = false 
		else:
			await get_tree().create_timer(0.01).timeout
			queue_free()
			
	else:
		return
