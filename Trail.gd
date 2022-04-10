extends Line2D

export(NodePath) var target_path

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var point
var target

# Called when the node enters the scene tree for the first time.
func _ready():
    print("Trail ready")
    target = get_node(target_path)
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    point = target.global_position
    add_point(point)
