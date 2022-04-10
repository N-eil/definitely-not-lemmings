extends Node2D

onready var l1 = load("res://Levels/Intro.tscn")

onready var shiokkos_label = $CanvasLayer/GUI/Bottomstuff/Stats/Shiokkos/Label
onready var goal_label = $CanvasLayer/GUI/Bottomstuff/Stats/GoalCount/Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_level

# Called when the node enters the scene tree for the first time.
func _ready():
    for child in $CanvasLayer/GUI/Bottomstuff/Hotbar.get_children():
        if child is VBoxContainer:
           child.connect("selected_magic", self, "set_active")

    current_level = l1.instance()
    add_child(current_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func set_active(type):
    print(type)
    current_level.active_magic_type = type

func shiokko_spawned(remain):
    shiokkos_label.text = str(remain)
    
func shiokko_arrived(score, goal):
    goal_label.text = str(score) + " / " + str(goal)
