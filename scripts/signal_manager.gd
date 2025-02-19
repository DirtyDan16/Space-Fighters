# SignalManager.gd
extends Node2D

# Define your signals here
signal stopEnemyShoot
signal stopEnemyMove
signal laserCollisionParticles

# Singleton setup
var instance: SignalManager = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self

# Connect a signal
func connect_signal(signal_name: String, target: Object, method: String) -> void:
	if instance.has_signal(signal_name):
		instance.connect(signal_name,Callable(target,method))
	else:
		print("Signal not found: ", signal_name)

# Disconnect a signal
func disconnect_signal(signal_name: String, target: Object, method: String) -> void:
	if instance.has_signal(signal_name):
		instance.disconnect(signal_name,Callable(target,method))
	else:
		print("Signal not found: ", signal_name)

# Emit a signal
func emit_a_signal(signal_name: String, additional_parameters: Array):
	if instance.has_signal(signal_name):
		instance.emit_signal(signal_name,additional_parameters)
		#print("signal with name: ",signal_name," emitted")
	else:
		print("Signal not found: ", signal_name)
