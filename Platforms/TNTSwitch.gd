extends StaticBody2D

onready var switch_hitbox : Area2D = $SwitchHitbox
export var SWITCH_INDEX = -1
signal tnt_triggered(SWITCH_INDEX)

func handle_body_entered(_body):
	$AnimationPlayer.play("Press")
	emit_signal("tnt_triggered", SWITCH_INDEX)

func _ready():
	switch_hitbox.connect("body_entered", self, "handle_body_entered")