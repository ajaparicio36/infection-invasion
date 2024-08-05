extends Node

var playerAlive: bool
var player_pos: Vector2
var playerHitbox: Area2D

var current_wave: int 
var moving_to_next_wave: bool

var zombieDamageZone: Area2D
var zombieDamageAmount: int
