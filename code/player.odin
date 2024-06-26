package main

import rl "vendor:raylib"


Animation_Name :: enum {
	Idle,
	Idle2,
	Walk,
	Jump,
}

AnimationStruct :: struct {
	texture:      rl.Texture2D,
	numFrames:    u32,
	frameTimer:   f32,
	currentFrame: u32,
	frameLength:  f32,
	name:         Animation_Name,
}


initilizePlayer :: proc () -> (AnimationStruct, AnimationStruct, AnimationStruct, AnimationStruct, rl.Vector2, rl.Vector2, bool, bool) {

	playerWalk := AnimationStruct {
		texture     = rl.LoadTexture("resources/player/swordsman/Walk.png"),
		numFrames   = 8,
		frameLength = f32(0.1),
		name        = .Walk,
	}

	playerIdle := AnimationStruct {
		texture     = rl.LoadTexture("resources/player/swordsman/Idle.png"),
		numFrames   = 8,
		frameLength = f32(0.15),
		name        = .Idle,
	}

	playerIdle2 := AnimationStruct {
		texture     = rl.LoadTexture("resources/player/swordsman/Idle_2.png"),
		numFrames   = 3,
		frameLength = f32(1.5),
		name        = .Idle2,
	}

	playerJump := AnimationStruct {
		texture     = rl.LoadTexture("resources/player/swordsman/Jump.png"),
		numFrames   = 8,
		frameLength = f32(0.1),
		name        = .Jump,
	}

    playerVelocity: rl.Vector2

	playerFlip: bool

	playerPosition: rl.Vector2
	playerGoingToRight := true
	playerGrounded := true

    return  playerWalk, playerIdle, playerIdle2, playerJump, playerVelocity, playerPosition, playerFlip, playerGrounded
}