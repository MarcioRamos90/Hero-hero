package enemy

import rl "vendor:raylib"

direction := [2]string {"right", "left"} 

controller :: proc (position: ^rl.Vector2, isGrounded: ^bool, isFliped: ^bool, positionToFollow: ^rl.Vector2)
{
    currentFrame := u32(rl.GetTime() / 5) % len(direction)

    currentDirection := direction[currentFrame]
    
    if position^.x < positionToFollow^.x {
        position^.x += 1
        isFliped^ = false
    } else if position^.x > positionToFollow^.x {
        position^.x -= 1
        isFliped^ = true
    }
}