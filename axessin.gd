extends CharacterBody2D

enum State {SCANNING, THINKING, PROJECTILE, SLICE, DASH, RECOVERY, DAMAGED}
var state : State = State.SCANNING
var target : Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$detect_player.area_entered.connect(player_entering)
	$weak_point.area_entered.connect(impact)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var idle_anim : Tween = create_tween()
	match state:
		State.SCANNING:
			idle_anim.tween_property($Axessin,"position",Vector2($Axessin.position.x,$Axessin.position.y - 3),0.5)
			idle_anim.tween_property($Axessin,"position",Vector2($Axessin.position.x,$Axessin.position.y + 3),0.5)
			
			
		State.THINKING:
			pass
		State.PROJECTILE:
			pass
		State.SLICE:
			pass
		State.DASH:
			pass
		State.RECOVERY:
			pass
		State.DAMAGED:
			pass


func player_entering(area : Area2D):
	state = State.THINKING
	target = area
	



func impact(_area : Area2D):
	state = State.DAMAGED
