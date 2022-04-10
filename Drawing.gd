extends Node2D

var drawing_segments = Array()
var segment_count = 0

var full_circles = Array()
var full_shapes = Array()

var has_drawing = false

var mouse_held = false
export(Color) var draw_colour
export(Color) var complete_colour

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _draw():
    if (!has_drawing): return
    for segment in range(segment_count):
        if(drawing_segments[segment].points_count > 1):
            for index in range(drawing_segments[segment].points_count-1):
                draw_line(drawing_segments[segment].points[index], drawing_segments[segment].points[index+1], draw_colour, 3)

    for c in full_circles:
        draw_circle(c[0], c[1], complete_colour)

    for s in full_shapes:
        for index in range(s.size() -1):
            draw_line(s[index], s[index+1], complete_colour, 3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _input(event):
   # Mouse in viewport coordinates.
    if event is InputEventMouseButton && !mouse_held: #This is a click
#        print("Mouse Click at: ", event.position - global_position)
        mouse_held = true
        drawing_segments.push_back({
            "points" : Array(),
            "points_count" : 0
        })
        has_drawing = true
        segment_count += 1
        
    elif event is InputEventMouseButton && mouse_held: #This is an unclick
#        print("Mouse Unclick at: ", event.position)
        mouse_held = false
        var circle_stats = detect_circle(drawing_segments[segment_count-1].points)
        if (circle_stats):
            full_circles.push_back(circle_stats)
            remove_latest_drawing()
            update()
            return
            
        var lightning_stats = detect_lightning(drawing_segments[segment_count-1].points)
        if (lightning_stats):
            full_shapes.push_back(lightning_stats)
            remove_latest_drawing()
            update()
            return
            
        var pentagram_stats = detect_pentagram(drawing_segments[segment_count-1].points)
        if (pentagram_stats):
            full_shapes.push_back(pentagram_stats)
            remove_latest_drawing()
            update()    
            return
            
    if event is InputEventMouseMotion && mouse_held:
        drawing_segments[segment_count-1].points.push_back(event.position - global_position)
        drawing_segments[segment_count-1].points_count += 1
#        print("Mouse Motion at: ", event.position - global_position)
        update()

   # Print the size of the viewport.
   #print("Viewport Resolution is: ", get_viewport_rect().size)

func remove_latest_drawing():
    drawing_segments.pop_back()
    segment_count -= 1

# Uses http://www.cs.bsu.edu/homepages/kjones/kjones/circles.pdf method D to find a circle of best fit for points
func detect_circle(points):
        
    var MAX_CIRCLE_VARIANCE = 0.15
    var MAX_ALLOWED_CORNER_ANGLE = PI / 3
    var MAX_ALLOWED_CORNER_COUNT = 2
    var MAX_RADIUS = 200
    
    var point_count = points.size() 
    if point_count < 1: return false
    
    var max_x = -10000
    var min_x = 10000
    var max_y = -10000
    var min_y = 10000
    
    # Trim extra points from forgetting to release button. New final point is point closest to start
    var closest_distance = 100000
    var closest_index = 0
    
    for i in range(floor(point_count/2),point_count-1):
        var d = points[0].distance_to(points[i])
        if d < closest_distance:
            closest_distance = d
            closest_index = i

    points = points.slice(0, closest_index)
    point_count = points.size()
    if point_count <= 5: return false

    # Discount squares or other shapes where the corners are too sharp
    var prev_angle = wrapf((points[0].angle_to_point(points[1])), 0, 2*PI)
    var corner_count = 0
    for p in range(point_count - 1):
        var new_angle = wrapf((points[p].angle_to_point(points[p+1])), 0, 2*PI)
        if angle_diff(new_angle, prev_angle) > MAX_ALLOWED_CORNER_ANGLE:
            corner_count += 1
        prev_angle = new_angle
        
    if corner_count > MAX_ALLOWED_CORNER_COUNT:
        print("Found %s corners and discarded shape." % corner_count)
        return false
        
    # Actually find circle
    var sum_x = 0
    var sum_y = 0
    var sum_x_2 = 0
    var sum_y_2 = 0
   
    for p in points:
        sum_x += p.x
        sum_y += p.y
        sum_x_2 += pow(p.x,2)
        sum_y_2 += pow(p.y,2)
        if (p.x > max_x): max_x = p.x
        if (p.y > max_y): max_y = p.y
        if (p.x < min_x): min_x = p.x
        if (p.y < min_y): min_y = p.y
    
    var mean_x = sum_x / point_count
    var mean_y = sum_y / point_count
    var mean_x_2 = sum_x_2 / point_count
    var mean_y_2 = sum_y_2 / point_count
    
    var x_diff_array = Array()
    var y_diff_array = Array()
    var x_2_diff_array = Array()
    var y_2_diff_array = Array()
    
    for p in points:
        x_diff_array.push_back(p.x - mean_x)
        y_diff_array.push_back(p.y - mean_y)
        x_2_diff_array.push_back(pow(p.x,2) - mean_x_2)
        y_2_diff_array.push_back(pow(p.y,2) - mean_y_2)
    
    var m = point_count * (point_count-1)
    
    if (m == 0): return false
    
    var A = m * covariance(x_diff_array, x_diff_array, point_count)
    var B = m * covariance(x_diff_array, y_diff_array, point_count)
    var C = m * covariance(y_diff_array, y_diff_array, point_count)
    var D = 0.5 * m * ( covariance(x_diff_array, y_2_diff_array, point_count) + covariance(x_diff_array, x_2_diff_array, point_count))
    var E = 0.5 * m * ( covariance(y_diff_array, x_2_diff_array, point_count) + covariance(y_diff_array, y_2_diff_array, point_count))
    
    var denom = A * C - B * B
    var a = (D * C - B * E) / denom
    var b = (A * E - B * D) / denom
    
    var point_to_radius_sum = 0
    for p in range(point_count):
        point_to_radius_sum  += sqrt(pow(points[p].x - a,2) + pow(points[p].y - b,2))
        
    var r = point_to_radius_sum / point_count

    print("x is %s , y is %s , r is %s" % [a, b, r])
    
    var center = Vector2(a, b)
    
    # Discard circles that are too big
    if (r > MAX_RADIUS): return false
    
    # Discard circles which are centered outside the points
    if (a < min_x || a > max_x || b < min_y || b > max_y):
        print("%s to %s : %s to %s" % [min_x, max_x, min_y, max_y])
        print("Circle center was too far out and discarded")
        return
    
    # Found the best circle.  Now calculate just how best it is
    var distances = Array()
    var distance_sum = 0
    
    for p in points:
        var d = center.distance_to(p)
        distances.push_back(d)
        distance_sum += d    
    
    var distance_mean = distance_sum / point_count
    
    var square_diff_sum = 0
    for d in distances:
        square_diff_sum += (pow(d - distance_mean, 2))
    var variance = square_diff_sum / point_count
    var normalized_variance = sqrt(variance) / distance_mean
    

    # Reject circles that have too much variance
    if (normalized_variance > MAX_CIRCLE_VARIANCE): 
        print("Normalized variance %s which is bigger than MAX %s"  % [normalized_variance, MAX_CIRCLE_VARIANCE])
        return false
    
    # Also reject circles that are too incomplete
    print("Remaining to close %s " % (points[0].distance_to(points[point_count-1])))
    if ((points[0].distance_to(points[point_count-1])) > r ): return false
        
    return [center,r]


func covariance(list1, list2, count):
    if (list1.size() != count || list2.size() != count):
        print("COVARIANCE LISTS SIZE ERROR")
    
    var sum = 0
    
    for i in range(count):
        sum += (list1[i] * list2[i])
    
    return sum/count

# Difference between two angles in radians
func angle_diff(a1, a2):
        var ad = abs(a1 - a2)
        if (ad > PI):
            ad -= 2*PI
        return abs(ad)
        
func detect_tornado(points):
    var point_count = points.size()
    if (point_count < 5): return false


func detect_lightning(points):
    
    var LIGHTNING_ANGLE_LEEWAY = PI / 8
    var MAX_VERTICAL_LIGHTNING_SKEW = 40
        
    var point_count = points.size()
    if (point_count < 5): return false

    
#    var prev_angle = wrapf((points[0].angle_to_point(points[1])), 0, 2*PI)
#    for p in range(point_count - 1):
#        var new_angle = wrapf((points[p].angle_to_point(points[p+1])), 0, 2*PI)
##        print("%s %s difference is %s" % [new_angle, prev_angle, angle_diff(new_angle, prev_angle)])
#        if angle_diff(new_angle, prev_angle) > PI / 3:
#            key_points.push_back(points[p])
#
#        prev_angle = new_angle 
        
    # Find leftmost and rightmost points
    var max_x = -10000
    var min_x = 10000
    var left_p
    var right_p
    for p in points:
        if (p.x > max_x):
            right_p = p
            max_x = p.x
        if (p.x < min_x):
            left_p = p
            min_x = p.x
                        
    var key_points = [points[0], left_p, right_p, points[point_count-1]] #Top, two corners, and bottom
#    key_points.push_back(points[0])        
#    key_points.push_back(left_p)
#    key_points.push_back(right_p)
#    key_points.push_back(points[point_count-1])
    
    # Incorrect number of points for lightning bolt
    if key_points.size() != 4:
        print("Wrong number of key points for lightning!")
        print(key_points)
        return false

    # Incorrect position of points for lightning bolt
    elif(!(key_points[0].y < key_points[1].y &&
       key_points[0].y < key_points[2].y &&
       key_points[1].y < key_points[3].y &&
       abs(key_points[0].x - key_points[3].x) < MAX_VERTICAL_LIGHTNING_SKEW)):
        print("Points are in the wrong position for lightning!")
        print(key_points)
        return false

    # Incorrect angle of points for lightning bolt
    var a1 = key_points[0].angle_to_point(key_points[1])
    var a2 = wrapf(key_points[1].angle_to_point(key_points[2]), 0, PI*2)
    var a3 = key_points[2].angle_to_point(key_points[3])
    
    if(!(abs(a1 + PI/4) < LIGHTNING_ANGLE_LEEWAY &&
         abs(a2 - PI) < LIGHTNING_ANGLE_LEEWAY &&
         abs(a3 + PI/4) < LIGHTNING_ANGLE_LEEWAY)):
            print("Points are poorly angled for lightning!")
            print(key_points)
            return false

    return key_points


func detect_pentagram(points):
    var PENTAGRAM_ANGLE_LEEWAY = PI / 8
        
    var point_count = points.size()
    if (point_count < 5): return false

    var key_points = Array()

    #Find highest point, furthest left and right points
    var max_left = 10000
    var max_right = -10000
    var min_y = 10000
    var left_t
    var right_t
    var high_p
    for p in points:
        if (p.y < min_y):
            high_p = p
            min_y = p.y
        if (p.x > max_right):
            right_t = p
            max_right = p.x
        if (p.x < max_left):
            left_t = p
            max_left = p.x
                        

    # Find leftmost and rightmost points
    max_left = -10000
    max_right = -10000
    var left_p
    var right_p
    for p in points:
        if (p.x > high_p.x && p.y > max_right):
            right_p = p
            max_right = p.y
        if (p.x < high_p.x && p.y > max_left):
            left_p = p
            max_left = p.y
    
    key_points.push_back(left_p)
    key_points.push_back(high_p)
    key_points.push_back(right_p)
    key_points.push_back(left_t)
    key_points.push_back(right_t)
    key_points.push_back(left_p)

    var angles = Array()
    for i in range(key_points.size()-1):
        angles.push_back((wrapf(key_points[i].angle_to_point(key_points[i+1]), 0, PI*2)))

    
    print(angles)

    if(!(abs(angles[0] - 3 * PI / 5) < PENTAGRAM_ANGLE_LEEWAY &&
         abs(angles[1] - 7 * PI / 5) < PENTAGRAM_ANGLE_LEEWAY &&
         abs(angles[2] - PI / 5) < PENTAGRAM_ANGLE_LEEWAY &&
         abs(angles[3] -  PI) < PENTAGRAM_ANGLE_LEEWAY &&
         abs(angles[4] - 9 * PI / 5) < PENTAGRAM_ANGLE_LEEWAY)):
            print("Angles are incorrect for a pentagram!")
            print(angles)
            return false
    

    return key_points
