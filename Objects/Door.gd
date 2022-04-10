extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Vector2) var moved_pos
export(float) var speed = 200

var start_pos
var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
    start_pos = transform.origin
    if moved_pos.x == 0:
        moved_pos.x = start_pos.x
    if moved_pos.y == 0:
        moved_pos.y = start_pos.y
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var move_speed = speed * 0.5
    var target = start_pos
    if open:
        target = moved_pos
        move_speed = move_speed / 0.5

    position = position.move_toward(target, delta * move_speed)


func move_door(o):
    open = o
#    if open:
#        transform.origin = moved_pos
#    else:
#        transform.origin = start_pos
