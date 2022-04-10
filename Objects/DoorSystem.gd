extends Node2D

onready var button_up = $Button/Sprite
onready var button_down = $Button/Sprite2

var doors = []

export(Color) var system_colour

var activating_body

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var button_active

# Called when the node enters the scene tree for the first time.
func _ready():
    modulate = system_colour
    
    for child in get_children():
        if child is KinematicBody2D:
            doors.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func toggle_button(pressed):
    button_active = pressed
    for door in doors:
        door.move_door(pressed)
    button_down.visible = pressed
    button_up.visible = !pressed
        


func _on_Button_body_entered(body):
    if not button_active:
        activating_body = body
        toggle_button(true)


func _on_Button_body_exited(body):
    if button_active and body == activating_body:
        toggle_button(false)
