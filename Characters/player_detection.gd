extends "res://Characters/TemplateCharacter.gd"

const FOV_TOLERANCE = 20.0
const RED = Color(1, 0.25, 0.25)
const WHITE = Color(0.9, 0.9, 0.9)
const MAX_DETECTION_RANGE = 512


var Player
var player_detected = false

func _ready():
	Player = get_node("/root").find_node("Player", true, false)
	$Debug_sprite_1.rotation_degrees = FOV_TOLERANCE
	$Debug_sprite_2.rotation_degrees = -FOV_TOLERANCE
	
func _process(delta):
	if Player_in_FOV() and Player_in_LOS():
		$Torch.color = RED
	else:
		$Torch.color = WHITE
	$Debug_sprite_1.rotation_degrees = FOV_TOLERANCE
	$Debug_sprite_2.rotation_degrees = -FOV_TOLERANCE

	
func Player_in_FOV():
	var npc_facing_direction = Vector2(1, 0).rotated(global_rotation)
	var direction_to_PLayer = (Player.global_position - global_position).normalized()
	
	if abs(direction_to_PLayer.angle_to(npc_facing_direction)) <= deg2rad(FOV_TOLERANCE):
		if player_detected == false:
			print("player detected\n", rad2deg(direction_to_PLayer.angle_to(npc_facing_direction)))
			player_detected = true
		return true
	else:
		if player_detected == true:
			print("player undetected\n", rad2deg(direction_to_PLayer.angle_to(npc_facing_direction)))
			player_detected = false
		return false
		
func Player_in_LOS():
	var space = get_world_2d().direct_space_state
	var LOS_obstacle = space.intersect_ray(global_position, 
											Player.global_position, 
											[self],
											collision_mask)
											
	if not LOS_obstacle:
		return false
		
	var distance_to_player = Player.global_position.distance_to(global_position)
	
	if LOS_obstacle.collider == Player and distance_to_player <= MAX_DETECTION_RANGE:
		return true
	else:
		return false
