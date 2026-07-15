extends StaticBody2D

var time_alive : float = 0.7


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.area_entered.connect(player_entered)
	$Timer.timeout.connect(destruction)


func destruction():
	#Animación (todavía no decidido)
	var fall_anim : Tween = get_tree().create_tween()
	fall_anim.tween_property(self,"global_position",Vector2(global_position.x,global_position.y + 100),1.0)
	await get_tree().create_timer(0.1).timeout
	queue_free()



func player_entered(_body):
	$Timer.start(time_alive)
