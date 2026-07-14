extends Area2D

@export var sweep_duration: float = 1.5      # cuánto tarda en barrer de un lado a otro
@export var angle_start: float = -360       # grados, desde la derecha del jefe
@export var angle_end: float = -180           # grados, hacia la izquierda del jefe
@export var beam_length: float = 800.0
@export var damage_per_second: float = 20.0


@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var line: Line2D = $Line2D  # opcional, visual del rayo

func _ready() -> void:
	_update_visual()
	
	rotation_degrees = angle_start
	var tween := create_tween()
	tween.tween_property(self, "rotation_degrees", angle_end, sweep_duration)
	tween.tween_callback(queue_free)  # se destruye al terminar el barrido

func _physics_process(_delta: float) -> void:
	pass

func _update_visual() -> void:
	if line:
		line.points = [Vector2.ZERO, Vector2.RIGHT * beam_length]
	if collision_shape and collision_shape.shape is RectangleShape2D:
		collision_shape.shape.size = Vector2(beam_length, collision_shape.shape.size.y)
		collision_shape.position = Vector2(beam_length / 2.0, 0)
