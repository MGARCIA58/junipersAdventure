extends Node
const MAIN_MUSIC = preload("uid://bgk4bkq420luu")
const COIN = preload("uid://kgrl2cybfl6b")
const HIT_FRUIT = preload("uid://cl2jsewjtx45k")
const PLAYER_DAMAGE_1 = preload("uid://bj3foqfxdjv3t")
const PLAYER_DAMAGE_2 = preload("uid://2d5tr6c8yupy")
const PLAYER_DAMAGE_3 = preload("uid://bcofu87e4r5i0")
const BAT_ATTACKING_1 = preload("uid://b0m3lw3po382q")
const BAT_ATTACKING_2 = preload("uid://1e43cxv6l4ep")
const CAKE_BEE = preload("uid://bx1y48bv02dm1")
const CHAMELEON = preload("uid://c6xic7yw7k1m1")
const JUMP = preload("uid://cfsypja6omuwl")
const MOCK_1 = preload("uid://bj01n0cvutvi2")
const MOCK_2 = preload("uid://bort15so4ams3")
const MOCK_3 = preload("uid://dxqiueij5y8xe")
const MOCK_4 = preload("uid://qcl6lu6qj5sm")
const INTRO_3 = preload("uid://bltgokxe2p2k8")
const PLANT_BULLET = preload("uid://dkviydp8luref")
const PANAL = preload("uid://bxpgr06j1g3rm")
const PlayerDamageArray = [PLAYER_DAMAGE_1,PLAYER_DAMAGE_2,PLAYER_DAMAGE_3]
const BatAttackingArray = [BAT_ATTACKING_1,BAT_ATTACKING_2]
const PlayerMockingArray = [MOCK_1,MOCK_2,MOCK_3,MOCK_4]
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@export var stream_players: Array[AudioStreamPlayer]
var panal_player: AudioStreamPlayer

func play_audio(clip: AudioStream, volume: float) -> void:
	var free_player: AudioStreamPlayer = get_free_audio_player()
	if free_player:
		free_player.stream = clip
		free_player.volume_db = volume
		free_player.play()
		if clip == PANAL:
			panal_player = free_player
		
func play_music() -> void:
		music_player.stream = MAIN_MUSIC
		music_player.volume_db = 4
		music_player.play()	
		
func play_intro() -> void:
		music_player.stream = INTRO_3
		music_player.volume_db = 4
		music_player.play()	

func get_free_audio_player() -> AudioStreamPlayer:
	for audio: AudioStreamPlayer in stream_players:
		if not audio.playing:
				return audio
	return null

func play_coin() -> void:
	play_audio(COIN, 20)
	
func play_hit_fruit()->void:
	play_audio(HIT_FRUIT, 20)
		
func play_bat_attacking() -> void:
	play_audio(BatAttackingArray.pick_random(), 16)

func play_player_damage() -> void:
	play_audio(PlayerDamageArray.pick_random(), 16)
	
func play_bee_attacking() -> void:
	play_audio(CAKE_BEE, 16)
	
func play_chameleon_attacking() -> void:
	play_audio(CHAMELEON, 16)
	
func play_player_jump() -> void:
	play_audio(JUMP, 16)

func play_player_mocking() -> void:
	play_audio(PlayerMockingArray.pick_random(), 16)
	
func play_plant_bullet() -> void:
	play_audio(PLANT_BULLET, 16)

func play_panal() -> void:
	play_audio(PANAL, 16)

func stop_panal() -> void:
	if not panal_player:
		return
	panal_player.stop()

func _on_music_player_finished() -> void:
	play_music()
