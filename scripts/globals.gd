extends Node

var playerAlive: bool
var player_pos: Vector2
var playerHitbox: Area2D

var current_wave: int 
var moving_to_next_wave: bool

var player_name: String

var all_player_scores: Dictionary
var zombieDamageZone: Area2D
var zombieDamageAmount: int

var bruteDamageZone: Area2D
var bruteDamageAmount: int

var sprinterDamageZone: Area2D
var sprinterDamageAmount: int
