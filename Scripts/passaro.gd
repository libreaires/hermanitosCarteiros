extends Enemy

class_name Passaro

# ---------- INSPETOR ----------
@export_group("Movimento")
@export_range(0.0, 1000.0, 1.0, "or_greater") var velocidade: float = 20.0  # velocidade do voo
@export_enum("Direita:1", "Esquerda:-1") var direcao_inicial: int = 1
@export var limite_esquerdo: float = -190.0  # ate onde ele voa para a esquerda
@export var limite_direito: float = 190.0    # ate onde ele voa para a direita

@export_group("Onda")
@export var ondular: bool = false            # false = voo reto | true = voo em onda
@export var amplitude: float = 6.0           # altura da "onda" (so vale se ondular = true)
@export var frequencia: float = 4.0          # rapidez da "onda" (so vale se ondular = true)

@export_group("Queda")
@export var gravidade_queda: float = 600.0   # aceleracao da queda depois de morto

# ---------- ESTADO ----------
var base_y: float = 0.0
var tempo: float = 0.0
var direcao: int = 1
var vivo: bool = true
var caindo: bool = false
var velocidade_queda: float = 0.0


func _ready() -> void:
	base_y = position.y
	direcao = direcao_inicial


func _physics_process(delta: float) -> void:
	if caindo:
		_cair(delta)
		return
	if not vivo:
		return

	# Movimento horizontal
	position.x += velocidade * direcao * delta

	if position.x < limite_esquerdo:
		direcao = 1
	elif position.x > limite_direito:
		direcao = -1

	animated_sprite_2d.flip_h = direcao < 0

	# Movimento vertical: onda opcional
	if ondular:
		tempo += delta
		position.y = base_y + sin(tempo * frequencia) * amplitude
	else:
		position.y = base_y


# Depois de pisado: cai ate encostar num galho ou no chao e fica parado la.
func _cair(delta: float) -> void:
	velocidade_queda = min(velocidade_queda + gravidade_queda * delta, 300.0)
	position.y += velocidade_queda * delta
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		position.y = ray_cast_2d.get_collision_point().y - 2
		caindo = false


func _die() -> void:
	vivo = false
	caindo = true
	set_collision_layer_value(3, false)  # nao machuca mais
	animated_sprite_2d.stop()
	animated_sprite_2d.flip_v = true     # de barriga para cima
	ray_cast_2d.enabled = true           # passa a procurar o chao
