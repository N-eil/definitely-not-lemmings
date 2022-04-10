extends Area2D

const COUNTDOWN = 1.5
const FADE_SPEED = 5

onready var bolt = load("res://Magic/LightningBolt.tscn")
onready var bolt_instance = bolt.instance()


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time_left
var fading = false
var shot = false

onready var tilemap = $"../TileMap"

func bolt_hit():
    fading = true

func shoot_lightning():
    shot = true
    add_child(bolt_instance)
    bolt_instance.connect("hit_something", self, "bolt_hit")

#    queue_free()


# Called when the node enters the scene tree for the first time.
func _ready():
    modulate.a = 2
    time_left = COUNTDOWN
    bolt_instance.set_name("bolt")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    time_left -= delta
    if time_left <= 0 and not shot:
        shoot_lightning()
    if fading:
        modulate.a -= (delta * FADE_SPEED)
        if (modulate.a <= 0):
            queue_free()
        
