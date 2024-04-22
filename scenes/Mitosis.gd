extends Node2D

var spawn_cooldown = true
var ember_copy: PackedScene = load("res://scenes/ember_enemy.tscn")

func spawn(): 
		if spawn_cooldown == true and Game.ember_cap == false:
			spawn_cooldown = false
			var new_ember = ember_copy.instantiate()
			new_ember.position = get_parent().position + Vector2(randf_range(-100, 100), randf_range(-100, 100))
			get_tree().get_root().get_node("World").add_child(new_ember) 
			
			$MitosisCooldown.start()
			print("Enemy Spawned!")
			
			Game.ember_count += 1
			print(Game.ember_count)
			if Game.ember_count >= 20:
				Game.ember_cap = true
				print("EMBER CAP HAS BEEN REACHED")

func _on_mitosis_cooldown_timeout():
		spawn_cooldown = true
		spawn()
