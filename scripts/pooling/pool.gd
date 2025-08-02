class_name Pool extends Object

var template: PoolTemplate = null
var queue := []
var size := 0
var desired_size := 0
var pooled_amount := 0

func setup(new_template: PoolTemplate) -> void:
	template = new_template
	desired_size = template.default_size


## returns true if the size was adjusted
func adjust_size() -> bool:
	if size < desired_size:
		var object := template.template.instantiate()
		queue.append(object)
		pooled_amount += 1
		size += 1
		return true

	return false


func get_next() -> Variant:
	var next = queue.pop_at(0)
	pooled_amount -= 1
	if queue.size() < 2:
		desired_size += template.size_increase
		PoolManager.process_mode = Node.PROCESS_MODE_ALWAYS

	return next


## returns true if the pool gets filled
func return_to_pool(object: Variant) -> bool:
	queue.append(object)
	pooled_amount += 1
	return pooled_amount == size
