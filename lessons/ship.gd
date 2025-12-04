extends Area2D


var max_speed := 1200.0
var velocity := Vector2(0, 0)
var steering_factor := 3.0
var health := 10 #Starting Health Value
var gem_count := 0 #Starting Gem Value


func set_health(new_health: int) -> void:
	health = new_health
	get_node("UI/HealthBar").value = health 
	#Connecting the healthbar to the health value

func _process(delta: float) -> void:
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	var viewport_size := get_viewport_rect().size
	position.x = wrapf(position.x, 0, viewport_size.x)
	position.y = wrapf(position.y, 0, viewport_size.y)

	if direction.length() > 1.0:
		direction = direction.normalized()

	var desired_velocity := max_speed * direction
	var steering := desired_velocity - velocity
	velocity += steering * steering_factor * delta
	position += velocity * delta

	if velocity.length() > 0.0:
		get_node("Sprite2D").rotation = velocity.angle()
		#changed to allow the ship to rotate independently from the healthbar

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	set_health(health)
	#connecting the ship to the healthpacks so they can be picked up

func set_gem_count(new_gem_count: int) -> void:
	gem_count = new_gem_count
	get_node("UI/GemCount").text = "x" + str(gem_count)
# Changes the GemCount label to a string variable so the value can change

func _on_area_entered(area_that_entered: Area2D) -> void:
	if area_that_entered.is_in_group("gem"):
		set_gem_count(gem_count + 1)
		#Pickup gem values
	elif area_that_entered.is_in_group("healing_item"):
		set_health(health + 10)
		#pickup healthpack values
