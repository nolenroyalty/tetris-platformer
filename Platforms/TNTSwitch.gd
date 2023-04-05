extends StaticBody2D

onready var switch_trigger_box : Area2D = $SwitchTriggerBox
onready var animation_player : AnimationPlayer = $AnimationPlayer
export var SWITCH_INDEX = -1
signal tnt_triggered(SWITCH_INDEX)
var has_triggered_already = false
const ANIMATION_NAME = "Press"

func handle_animation_finished(name):
	if name == ANIMATION_NAME:
		emit_signal("tnt_triggered", SWITCH_INDEX)

func handle_body_entered(_body):
	if has_triggered_already: return
	has_triggered_already = true
	animation_player.play("Press")

func _ready():
	switch_trigger_box.connect("body_entered", self, "handle_body_entered")
	animation_player.connect("animation_finished", self, "handle_animation_finished")
#	animation_player.play("Press")
