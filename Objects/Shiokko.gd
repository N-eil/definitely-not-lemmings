extends KinematicBody2D

const MOVESPEED = 50
const FLAME_MULTIPLIER = 2.5
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_DISTANCE = 2
const SLOPE_THRESHOLD = deg2rad(46)

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var velocity = Vector2()
var direction = 1
var on_fire = false
var launching = false
var bottom = 585
var frozen = false

# Called when the node enters the scene tree for the first time.
func _ready():
    scale.x = -1
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func launch(strength):
    velocity.y = strength
    launching = true

func freeze():
    $AnimatedSprite.modulate = Color(0,0.4,0.95)
    $AnimatedSprite.stop()
    set_collision_layer_bit(4, true)
    frozen = true    
    
func unfreeze():
    $AnimatedSprite.modulate = Color(1,1,1)
    $AnimatedSprite.play()
    set_collision_layer_bit(4, false)
    frozen = false

func set_on_fire():
    if frozen:
        unfreeze()
        return
        
    on_fire = true
    $AnimatedSprite.speed_scale = FLAME_MULTIPLIER
    
func hit_wall():
    direction *= -1
    scale.x *= -1

func _physics_process(delta):
    
    if global_position.y > bottom + 100:
        queue_free()
    
    if frozen:
        return
    
    # Clamp to the maximum horizontal movement speed.
    velocity.x = MOVESPEED * direction
    if (on_fire):
        velocity.x *= FLAME_MULTIPLIER 

    # Vertical movement code. Apply gravity.
    var gravity_resistance = get_floor_normal() if is_on_floor() else Vector2.UP
    velocity -= gravity_resistance * gravity * delta
    
    
    var snap = SNAP_DIRECTION * SNAP_DISTANCE
    if launching:
        snap =  Vector2(0,0)
        launching = false
    velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true, 4, SLOPE_THRESHOLD)
    
    if is_on_wall():
        hit_wall()

