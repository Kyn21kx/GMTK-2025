extends Node

@warning_ignore("unused_signal")
## used to signal every pooled object to return to the pool
signal return_request()
## all the pooled objects returned to the pool
signal filled()

var templates_resource := preload("res://scripts/pooling/pool_templates.tres")

var pools: Dictionary[String, Pool] = {}


func _ready() -> void:
	var num_templates := templates_resource.templates.size()
	for template_idx in num_templates:
		var template := templates_resource.templates[template_idx]
		var pool := Pool.new()
		pool.setup(template)
		pools[template.name] = pool

	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta: float) -> void:
	for pool_name in pools:
		var pool := pools[pool_name]
		if pool.adjust_size():
			return

	process_mode = Node.PROCESS_MODE_DISABLED


func get_next(pool_name: String) -> Variant:
	return pools[pool_name].get_next()


func return_to_pool(pool_name: String, object: Variant) -> void:
	if pools[pool_name].return_to_pool(object):
		if full():
			filled.emit()


func full() -> bool:
	for pool_idx in pools:
		var pool := pools[pool_idx]
		if pool.pooled_amount != pool.size:
			return false

	return true
