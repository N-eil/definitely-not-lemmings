extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var currentInstruction = -1

# Order: Pentagram, goal, fire, wind, lightning, ice, door, UI bar, Remaining, Score
var locations = Array(
    [
        Vector2(377, 113),
        Vector2(1126, 418),  
        Vector2(281, 470),   
        Vector2(385, 470),   
        Vector2(496, 416),   
        Vector2(593, 470),   
        Vector2(1025, 417),   
        Vector2(979, 554),   
        Vector2(1337, 554)   
    ])

var sizes = Array(
    [
        Vector2(1,1),
        Vector2(0.8,0.7),
        Vector2(0.5,0.5),
        Vector2(0.5,0.5),
        Vector2(0.5,0.7),
        Vector2(0.5,0.5),
        Vector2(1,0.7),
        Vector2(2,0.7),
        Vector2(1.5,0.7)
    ])

onready var instructions_array = get_node("../AllInstructions").get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func next_instruction():
    currentInstruction += 1
    if currentInstruction == sizes.size() - 1:
        get_node("../../..").preload_next()
    
    if currentInstruction == sizes.size():
        get_node("../../..").go_next()
        return # Go to the real level!

    reposition(locations[currentInstruction], sizes[currentInstruction])

func reposition(new_position, new_size):
    print(currentInstruction)
    transform = Transform2D().scaled(new_size)
    transform.origin  = new_position
    instructions_array[currentInstruction].visible = true
    if (currentInstruction > 0):
        instructions_array[currentInstruction - 1].visible = false

func _input(event):
    if not (event is InputEventMouseButton and event.pressed):
        return
    if currentInstruction < 7:
        return
    next_instruction()

func _on_Arrow_input_event(viewport, event, shape_idx):
    if not (event is InputEventMouseButton and event.pressed):
        return
    next_instruction()
