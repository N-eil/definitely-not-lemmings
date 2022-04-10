extends Node2D


onready var shiokkos_label = $CanvasLayer/GUI/Bottomstuff/Stats/Shiokkos/Label
onready var goal_label = $CanvasLayer/GUI/Bottomstuff/Stats/GoalCount/Label

var level_list = Array(
    [
        "res://Levels/Tutorial.tscn",
        "res://Levels/Intro.tscn",
        "res://Levels/DistantButton.tscn",
        "res://Levels/Ascent.tscn",
        "res://Levels/Doors.tscn"
    ])
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_level
var next_level

var active_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    next_level = load(level_list[0])
    go_next()
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func set_active(type):
    current_level.active_magic_type = type

func shiokko_spawned(remain):
    shiokkos_label.text = str(remain)
    
func shiokko_arrived(score, goal):
    goal_label.text = str(score) + " / " + str(goal) + " HOME"

func preload_next():
    active_level += 1
    next_level = load(level_list[active_level])
    
func go_next():
    if current_level:
        current_level.queue_free()
    
    for child in $CanvasLayer/GUI/Bottomstuff/Hotbar.get_children():
        if child is VBoxContainer:
           child.connect("selected_magic", self, "set_active")
    
    if active_level == 1:
        get_node("/root/BGM").play()
    
    current_level = next_level.instance()
    add_child(current_level)
    move_child(current_level, 0)
