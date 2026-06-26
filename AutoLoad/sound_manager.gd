extends Node
const MAIN_MUSIC = preload("uid://bgk4bkq420luu")
const COIN = preload("uid://kgrl2cybfl6b")
const HIT_FRUIT = preload("uid://cl2jsewjtx45k")
const PLAYER_DAMAGE_1 = preload("uid://bj3foqfxdjv3t")
const PLAYER_DAMAGE_2 = preload("uid://2d5tr6c8yupy")
const PLAYER_DAMAGE_3 = preload("uid://bcofu87e4r5i0")
const PlayerDamageArray = [PLAYER_DAMAGE_1,PLAYER_DAMAGE_2,PLAYER_DAMAGE_3]
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@export var stream_players: Array[AudioStreamPlayer]

func play_audio(clip: AudioStream, volume: float) -> void:
	var free_player: AudioStreamPlayer = get_free_audio_player()
	if free_player:
		free_player.stream = clip
		free_player.volume_db = volume
		free_player.play()
		
func play_music() -> void:
		music_player.stream = MAIN_MUSIC
		music_player.volume_db = 4
		music_player.play()	

func get_free_audio_player() -> AudioStreamPlayer:
	for audio: AudioStreamPlayer in stream_players:
		if not audio.playing:
				return audio
	return null

func play_coin() -> void:
	play_audio(COIN, 20)

func play_hit_fruit() -> void:
	play_audio(HIT_FRUIT, 16)

func play_player_damage() -> void:
	play_audio(PlayerDamageArray.pick_random(), 16)

func _on_music_player_finished() -> void:
	play_music()
