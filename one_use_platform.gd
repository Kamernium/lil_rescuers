extends StaticBody2D

var time_alive : float = 0.7


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.area_entered.connect(player_entered)
	$Timer.timeout.connect(destruction)


func destruction():
	#Animación (todavía no decidido)
	await get_tree().create_timer(0.1).timeout
	queue_free()



func player_entered(_body):
	$Timer.start(time_alive)
