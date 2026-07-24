class_name Mutation


static var stats := _load_stats()


static func _load_stats() -> Dictionary[Mutation.Id, MutationStats]:
	var resources: Dictionary[Mutation.Id, MutationStats] = {}
	var dir := DirAccess.open("res://resources/mutation")
	for file_name in dir.get_files():
		var resource := load(dir.get_current_dir() + "/" + file_name)
		resources[resource.id] = resource
	return resources


enum Id {
	NONE = -1,
	
	DEFAULT,
	FARMER,
	SHOOTER,
	SHOTGUN,
	TACK,
	MISSILE,
}
