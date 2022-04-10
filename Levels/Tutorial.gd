extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var spawn_delay = 2
export(int) var spawn_count = 30
export(int) var count_to_win = 10


var active_magic_type
var shiokkos_scored = 0
var bottom_border = 585

# Called when the node enters the scene tree for the first time.
func _ready():
    $ShiokkoSpawner.paused = true
    $CanvasLayer/FaderOverlay.next_instruction()
    
#func _input(event):
#    if not (event is InputEventMouseButton and event.pressed):
#        return
#    var mouse_pos = get_viewport().get_mouse_position()
#
#    if mouse_pos.y > bottom_border:
#        return
#
#    var new_circle
#
#    if active_magic_type == 1:
#        new_circle = fire.instance()
#    elif active_magic_type == 2:
#        new_circle = wind.instance()
#    elif active_magic_type == 3:
#        new_circle = light.instance()
#    elif active_magic_type == 4:
#        new_circle = ice.instance()
#    else:
#        return
#
#    new_circle.position = mouse_pos
#    add_child(new_circle)
#
#func activate_magic(type):
#    active_magic_type = type
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
#
#func win_level():
#    print("YOU WIN")
#
#func _on_shiokko_entered_goal(_body):
#    shiokkos_scored += 1
#    get_parent().shiokko_arrived(shiokkos_scored, count_to_win)
#    if shiokkos_scored >= count_to_win:
#        win_level()
