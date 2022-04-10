extends VBoxContainer

signal selected_magic

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var highlighted
export(int) var type

func _draw():
    
    var colour = Color(0.4, 1.0, 0.2)
    
    if highlighted:
        draw_rect ( Rect2(Vector2(0,0), rect_size), colour, false, 3)

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_magic_GUI_input(event):
   if event is InputEventMouseButton && event.pressed:
        set_active(!highlighted)

func set_active(h):
    highlighted = h
    update()

    if h:
        print("emitting selection")
        emit_signal("selected_magic", type)
