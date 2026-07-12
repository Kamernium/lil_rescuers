extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Player.bossmode:
		$StaticBody2D.visible = true
		$StaticBody2D/CollisionShape2D.disabled = false
