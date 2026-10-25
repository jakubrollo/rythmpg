extends AudioStreamPlayer

@export var bpm := 98
@export var measures := 4
# Beats in "Way Back Then Loop.wav" land this many seconds after the 98 BPM grid (silence at the start).
@export var music_offset := 0.09

var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1

var closest = 0
# On the web, get_playback_position() always returns 0 (Godot plays audio as Web Audio samples),
# so the song is timed with the system clock from the moment it starts playing.
var use_clock = OS.has_feature("web")
var start_usec = 0
# Web samples don't loop either, so the song is restarted by hand when it ends.
var music_start_usec = 0
var music_started = false
# The export's HTML shell records when the browser actually starts the music (window.__gdMusic),
# so the beat can follow the Web Audio output clock, i.e. what the player hears.
var js_audio = use_clock and Engine.has_singleton("JavaScriptBridge")
const JS_SONG_POSITION = "(function(){var m=window.__gdMusic;if(!m)return -1e9;var c=m.ctx,now;if(c.getOutputTimestamp){var ts=c.getOutputTimestamp();if(ts.contextTime>0)now=ts.contextTime+(performance.now()-ts.performanceTime)/1000;}if(now===undefined)now=c.currentTime-(c.outputLatency||c.baseLatency||0);return now-m.start;})()"
var time_off_beat = 0.0

signal report_beat(position)
signal report_measure(position)

func _ready():
	sec_per_beat = 60.0 / bpm

func _physics_process(_delta):
	if use_clock and music_started and stream and (Time.get_ticks_usec() - music_start_usec) / 1000000.0 >= stream.get_length():
		play()
		music_start_usec = Time.get_ticks_usec()
	if playing:
		if use_clock:
			song_position = _web_song_position()
		else:
			song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
			song_position -= AudioServer.get_output_latency()
		song_position -= music_offset
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()

func _web_song_position() -> float:
	if js_audio:
		var pos = JavaScriptBridge.eval(JS_SONG_POSITION, true)
		if pos != null and pos > -1000.0:
			return pos
	return (Time.get_ticks_usec() - start_usec) / 1000000.0 - AudioServer.get_output_latency()

func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if measure > measures:
			measure = 1
		emit_signal("report_beat", song_position_in_beats)
		emit_signal("report_measure", measure)
		last_reported_beat = song_position_in_beats
		measure += 1

func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()


func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth) 
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)

func play_from_beat(beat, offset):
	play()
	seek(beat * sec_per_beat)
	start_usec = Time.get_ticks_usec() - int(beat * sec_per_beat * 1000000.0)
	music_start_usec = start_usec
	music_started = true
	beats_before_start = offset
	measure = beat % measures

func _on_StartTimer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() +
														AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		if js_audio:
			JavaScriptBridge.eval("window.__gdMusic = null;", true)
		play()
		start_usec = Time.get_ticks_usec()
		music_start_usec = start_usec
		music_started = true
		$StartTimer.stop()
	_report_beat()
