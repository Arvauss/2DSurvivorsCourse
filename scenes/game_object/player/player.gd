extends CharacterBody2D

const MAX_SPEED = 150
const ACCELERATION_SMOOTHING = 20

@onready var damage_interval_timer = $DamageIntervalTimer

var number_bodies_colliding = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColllisionArea2D.body_entered.connect(on_body_entered)
	$ColllisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * MAX_SPEED
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	return Vector2(x_movement, y_movement)
	
func check_deal_damage():
	if number_bodies_colliding == 0 || !damage_interval_timer.is_stopped() :
		return
	$HealthComponent.damage(1)
	damage_interval_timer.start()
	print($HealthComponent.current_health)
	
	
func on_body_entered(other_body : Node2D):
	number_bodies_colliding += 1
	check_deal_damage() 
	
	
func on_body_exited(other_body : Node2D):
	number_bodies_colliding -= 1


func on_damage_interval_timer_timeout():
	check_deal_damage()



