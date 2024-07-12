package enemy

import rl "vendor:raylib"

DimentionStruct :: struct {
    width: i32,
    height: i32
}

initilize :: proc () -> (DimentionStruct, rl.Vector2, rl.Vector2, bool, bool) {

    enemyVelocity: rl.Vector2
	enemyPosition := rl.Vector2 {f32(rl.GetScreenWidth() / 2), -200}
    enemyDimentions := DimentionStruct {width= 50, height= 100}

	enemyFlip := false
	enemyGoingToRight := true
	enemyGrounded := true

    return enemyDimentions, enemyVelocity, enemyPosition, enemyFlip, enemyGrounded
}