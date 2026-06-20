extends Node2D

# Pixel-Konfetti ohne GPU-Partikel/Shader.
#
# Zeichnet farbige Quadrate selbst per draw_rect und rundet jede Position auf
# ganze Pixel (floor). Dadurch laeuft es auch auf Mobile-Chrome/WebGL, wo
# custom Particle-Shader haeufig nicht funktionieren, und bleibt trotzdem
# exakt am Pixelraster ausgerichtet.

## Anzahl der Konfetti-Teilchen.
@export var count: int = 120
## Fallbeschleunigung in Pixel/s^2.
@export var gravity: float = 120.0
## Minimale/maximale Anfangsgeschwindigkeit nach unten.
@export var min_speed: float = 40.0
@export var max_speed: float = 90.0
## Bildschirmgroesse (Viewport) zum Verteilen/Zuruecksetzen der Teilchen.
@export var screen_size: Vector2 = Vector2(640, 480)

const COLORS = [
	Color("eb3333"),
	Color("f59a1a"),
	Color("f7e633"),
	Color("4dcc4d"),
	Color("3380f2"),
	Color("b34dd9"),
]

var _particles: Array = []

func _ready() -> void:
	# Tatsaechliche Viewport-Groesse uebernehmen (Basis 640x480 stimmt bei
	# stretch aspect "expand" auf Android nicht mehr).
	screen_size = get_viewport().get_visible_rect().size
	for i in count:
		# prefill=true -> beim Start ueber die ganze Hoehe verteilt.
		_particles.append(_make(true))

# Erzeugt ein Teilchen. Bei prefill ueber die Hoehe verteilt, sonst am oberen Rand.
func _make(prefill: bool) -> Dictionary:
	var y := randf() * screen_size.y if prefill else -randf() * 40.0
	return {
		"pos": Vector2(randf() * screen_size.x, y),
		"vel": Vector2(0.0, randf_range(min_speed, max_speed)),
		"color": COLORS[randi() % COLORS.size()],
		"size": float(randi_range(3, 6)),
	}

func _process(delta: float) -> void:
	for p in _particles:
		p.vel.y += gravity * delta
		p.pos += p.vel * delta
		if p.pos.y > screen_size.y + 8.0:
			# Unten raus -> oben neu starten.
			var n := _make(false)
			p.pos = n.pos
			p.vel = n.vel
			p.color = n.color
			p.size = n.size
	queue_redraw()

func _draw() -> void:
	for p in _particles:
		# Am Pixelraster einrasten.
		var pos := Vector2(floor(p.pos.x), floor(p.pos.y))
		draw_rect(Rect2(pos, Vector2(p.size, p.size)), p.color)
