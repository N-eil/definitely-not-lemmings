extends KinematicBody2D

const HORIZONTAL_SPREAD = 10
const LIGHTNING_SPEED = 150
signal hit_something

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moving_diagonally = true
var startX
var velocity = Vector2(0,0)
var moving = true

# Called when the node enters the scene tree for the first time.
func _ready():
    startX = position.x

func handle_lightning_collision(collision):
    if collision.collider is TileMap:
        var tile_pos = collision.collider.world_to_map(collision.position)
        collision.collider.set_cellv(tile_pos, -1)
    else:
        collision.collider.queue_free()
    emit_signal("hit_something")
    moving = false    

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if not moving:
        return
        
    if (moving_diagonally):
        velocity = Vector2(-5,10) * LIGHTNING_SPEED
    else:
        velocity = Vector2(5, 0) * LIGHTNING_SPEED

    if position.x < startX - HORIZONTAL_SPREAD:
        moving_diagonally = false
    if position.x > startX + HORIZONTAL_SPREAD:
        moving_diagonally = true

    var collision = move_and_collide(velocity * delta)
    if collision:   
        handle_lightning_collision(collision)
