package dragon

import rl "vendor:raylib"

direction := [4]string {"right", "left", "up", "down"} 

dragonController :: proc (dragonPosition: ^rl.Vector2, dragonGrounded: ^bool, dragonFlip: ^bool)
{
    currentFrame := u32(rl.GetTime() / 5) % len(direction)

    currentDirection := direction[currentFrame]
    
    if currentDirection == "right" {
        dragonPosition^.x += 1
        dragonFlip^ = false
    } else if currentDirection == "left" {
        dragonPosition^.x -= 1
        dragonFlip^ = true
    } /*else if currentDirection == "up" && dragonGrounded^ {
        dragonPosition^.y -= 100
        dragonGrounded^ = false

    }  else if currentDirection == "down" && !dragonGrounded^ {
        dragonPosition^.y += 1
    }*/
}