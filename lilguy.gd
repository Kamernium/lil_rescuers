extends Area2D

@export var speed : int = 1700


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DetectorPantalla.screen_exited.connect(screen_exit)
	self.area_entered.connect(collision)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta


func screen_exit():
	queue_free()


func collision(_area):
	queue_free()
