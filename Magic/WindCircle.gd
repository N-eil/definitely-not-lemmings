extends Area2D

const BASE_LAUNCH = -260
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var launch_strength = BASE_LAUNCH

# Called when the node enters the scene tree for the first time.
func _ready():
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _on_WindCircle_body_entered(body):
    print(body.name)
    body.launch(launch_strength)
