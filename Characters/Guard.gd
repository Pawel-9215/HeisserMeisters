extends "res://Characters/player_detection.gd"


onready var navigation = get_tree().get_root().find_node("Navigation2D", true, false)
onready var destinations = navigation.get_node("Destinations")

var motion
var possible_destinations
var path

export var nav_tolerance = 1
export var walk_speed = 0.5

func _draw():
	for point in path:
		draw_circle(point-global_position, 4.0, Color(255,255,255))
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	possible_destinations = destinations.get_children()
	make_path()
	
func _physics_process(delta):
	navigate()
	update()
	
func navigate():
	var distance_to_destination = position.distance_to(path[0])
	if distance_to_destination > nav_tolerance:
		move()
	else:
		update_path()
		
func move():
	look_at(path[0])
	motion = (path[0] - position).normalized()*(MAX_SPEED*walk_speed)
	
#	if is_on_wall():
#		make_path()
	
	move_and_slide(motion)

func update_path():
	if path.size() <= 1:
		if $Timer.is_stopped():
			$Timer.start()
	else:
		path.remove(0)
	
func make_path():
	var new_destination = possible_destinations[randi() % (possible_destinations.size()-1)]
	path = navigation.get_simple_path(position, new_destination.position, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Timer_timeout():
	make_path()
	
