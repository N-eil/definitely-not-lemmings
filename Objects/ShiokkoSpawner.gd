extends Node2D

onready var Shiokko = load("res://Objects/Shiokko.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var total_spawns = 10
var delay = 2

var time_left
var has_spawned = 0
var paused = false

func spawn():
    time_left = delay
    has_spawned += 1
    
    get_parent().get_parent().shiokko_spawned(total_spawns - has_spawned)
    var shiokko = Shiokko.instance()
    add_child(shiokko)
    

# Called when the node enters the scene tree for the first time.
func _ready():
    time_left = delay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if paused: 
        return
    if has_spawned < total_spawns:
        time_left -= delta
        if time_left <= 0:
            spawn()

