#Thanks random person in yt comments. Modified with AI, reviewed and corrected by me.
extends CanvasLayer

var menu_history: Array[String] = []
var transitioning := false


func _transition_to(target: String) -> bool:
    if transitioning:
        return false

    transitioning = true
    visible = true

    $AnimationPlayer.play("transition")
    await $AnimationPlayer.animation_finished

    var error = get_tree().change_scene_to_file(target)

    if error != OK:
        push_error("Failed to load scene: " + target)

        $AnimationPlayer.play_backwards("transition")
        await $AnimationPlayer.animation_finished

        visible = false
        transitioning = false
        return false

    await get_tree().process_frame

    $AnimationPlayer.play_backwards("transition")
    await $AnimationPlayer.animation_finished

    visible = false
    transitioning = false

    return true


func navigate_to(target: String) -> void:
    var current = get_tree().current_scene.scene_file_path

    if await _transition_to(target):
        menu_history.append(current)


func go_back() -> void:
    if menu_history.is_empty() or transitioning:
        return

    var previous = menu_history.pop_back()

    if not await _transition_to(previous):
        menu_history.append(previous)


func change_scene(target: String) -> void:
    await _transition_to(target)