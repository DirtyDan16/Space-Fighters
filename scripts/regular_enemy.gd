extends Node2D


#-----------------CONST
var _HP: int = 1

@onready var hp_display = $HpDisplay
@export var death_particles: PackedScene
@export var death_sfx: PackedScene

func _ready():
	await get_tree().create_timer(1).timeout
	hp_display.text = str(_HP);


# Method to set HP
func set_hp(new_hp: int):
	_HP = new_hp
	hp_display.text = str(_HP);

func get_hp() -> int:
	return _HP
	
var laserParticles: Object

signal laserCollisionParticles

func _on_area_entered(area):
	if area.is_in_group("Lasers"):
		area.queue_free();
		_HP=_HP-1;
		hp_display.text = str(_HP);
		var Position: Array
		Position.append(area.position) 
		SignalManager.emit_a_signal("laserCollisionParticles",Position)
		
	if _HP <= 0: 
		#add death particles, sfx and enemy removal
		var deathParticles := death_particles.instantiate();
		deathParticles.position = (global_position+area.position)/2
		deathParticles.emitting = true;
		get_tree().current_scene.add_child(deathParticles)
		var deathSfx = death_sfx.instantiate();
		deathSfx.play();
		get_tree().current_scene.add_child(deathSfx)
		
		queue_free();
		remove_from_group("Enemies");
