extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Player
var camera_body


# Called when the node enters the scene tree for the first time.
func _ready():
	camera_body = get_node("../CameraBody")
	Player = get_node("/root").find_node("Player", true, false)
	
func _process(_delta):
	update()
	
func _draw():
	var camera_position = camera_body.global_position - global_position
	var player_position = Player.global_position - global_position
	draw_line(camera_position, player_position, Color(255,255,255), 2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
