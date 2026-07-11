extends Area2D

@export var speed: float = 360.0
var target: Node2D = null

func _ready() -> void:
	area_entered.connect(on_area_entered)


func _physics_process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		queue_free()
		return
	
	var direction: Vector2 = (target.global_position - global_position).normalized()
	global_position += direction * speed * delta
	rotation = direction.angle()  # opcional, para orientar el sprite

func on_area_entered(area : Area2D):
	if area == target or area.is_in_group("projectiles"):
		queue_free()
