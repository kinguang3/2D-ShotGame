extends Node
'''
为定义信号的地方
'''
signal on_player_health_updated(current:float,max:float)
signal on_player_room_entered(room:LevelRoom)
signal on_portal_reach

signal on_enemy_die
signal on_room_cleared

signal on_coin_picked
