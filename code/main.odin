package main

import "core:fmt"
import "core:os"
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

updateAnimation :: proc(animation: ^AnimationStruct) {
	animation^.frameTimer += rl.GetFrameTime()

	if animation^.frameTimer > animation^.frameLength {
		animation^.currentFrame += 1
		animation^.frameTimer = 0

		if animation^.currentFrame == animation^.numFrames {
			animation^.currentFrame = 0
		}
	}
}

drawAnimation :: proc(animation: AnimationStruct, position: rl.Vector2, flip: bool) {

	width := f32(animation.texture.width)
	height := f32(animation.texture.height)

	drawPlayerSource := rl.Rectangle {
		x      = f32(animation.currentFrame) * width / f32(animation.numFrames),
		y      = 0,
		width  = width / f32(animation.numFrames),
		height = height,
	}

	if flip {
		drawPlayerSource.width = -drawPlayerSource.width
	}

	dest := rl.Rectangle {
		x      = position.x,
		y      = position.y,
		width  = width / f32(animation.numFrames),
		height = height,
	}

	rl.DrawTexturePro(
		animation.texture,
		drawPlayerSource,
		dest,
		{dest.width / 2, dest.height},
		0,
		rl.WHITE,
	)
}

Platform :: struct {
	position: rl.Vector2,
	texture: rl.Texture2D,
}

PixelwindowHeight :: 180

main :: proc() {
	// -------------------------------------------------------------------------
	//  INITIALIZATING
	// -------------------------------------------------------------------------

	screenWidth: i32 = 1280
	screenHeight: i32 = 720
	rl.InitWindow(screenWidth, screenHeight, "Hero hero")
	rl.SetWindowState({.WINDOW_RESIZABLE})

	// PLATFORM

	platforms : []rl.Rectangle = {
		{-20, 20, 300, 16},
		{330, 24, 300, 16},
	}

	platform_texture := rl.LoadTexture("resources/platforms/platform1.png")

	// PLAYER

	playerVelocity: rl.Vector2

	playerWalk := AnimationStruct {
		texture     = rl.LoadTexture("resources/swordsman/Walk.png"),
		numFrames   = 8,
		frameLength = f32(0.1),
		name        = .Walk,
	}

	playerIdle := AnimationStruct {
		texture     = rl.LoadTexture("resources/swordsman/Idle.png"),
		numFrames   = 8,
		frameLength = f32(0.15),
		name        = .Idle,
	}

	playerIdle2 := AnimationStruct {
		texture     = rl.LoadTexture("resources/swordsman/Idle_2.png"),
		numFrames   = 3,
		frameLength = f32(1.5),
		name        = .Idle2,
	}

	playerJump := AnimationStruct {
		texture     = rl.LoadTexture("resources/swordsman/Jump.png"),
		numFrames   = 8,
		frameLength = f32(0.1),
		name        = .Jump,
	}


	currentAnimation: AnimationStruct = playerIdle

	playerFlip: bool

	playerPosition: rl.Vector2
	playerGoingToRight := true
	playerGrounded := true

	rl.SetTargetFPS(500)

	currentFrame := 0

	framesCounter := 0
	framesSpeed := 6


	for !rl.WindowShouldClose() {
		// -------------------------------------------------------------------------
		//  UPDATING
		// -------------------------------------------------------------------------
		if rl.IsKeyPressed(rl.KeyboardKey.RIGHT) || rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
			playerVelocity.x = 200
			playerFlip = false
			if currentAnimation.name != .Walk {
				currentAnimation = playerWalk
			}
		} else if rl.IsKeyPressed(rl.KeyboardKey.LEFT) || rl.IsKeyDown(rl.KeyboardKey.LEFT) {
			playerVelocity.x = -200
			playerFlip = true
			if currentAnimation.name != .Walk {
				currentAnimation = playerWalk
			}
		} else if !playerGrounded {
			if currentAnimation.name != .Jump {
				currentAnimation = playerJump
			}
		} else {
			playerVelocity.x = 0
			if currentAnimation.name != .Idle {
				currentAnimation = playerIdle
			}
		}

		playerVelocity.y += 1500 * rl.GetFrameTime()

		if playerGrounded && rl.IsKeyPressed(.UP) {
			playerVelocity.y = -500
		}
        
		playerPosition += playerVelocity * rl.GetFrameTime()
        
        playerFeetCollider := rl.Rectangle {
            playerPosition.x - 10,
            playerPosition.y - 4,
            20,
            4,
        }
        
        playerGrounded = false

		for platform in platforms {
			if rl.CheckCollisionRecs(playerFeetCollider, platform) && playerVelocity.y > 0 {
				playerVelocity.y = 0
				playerPosition.y = platform.y
				playerGrounded = true
			}
		}


		// -------------------------------------------------------------------------
		//  DRAWING
		// ----------------------------------------------------------------------------
		rl.BeginDrawing()
		{
			rl.ClearBackground(rl.DARKBLUE)

			updateAnimation(&currentAnimation)
			screenHeight := f32(rl.GetScreenHeight())

			camera := rl.Camera2D {
				offset = {f32(rl.GetScreenWidth() / 2), screenHeight / 2},
				target = playerPosition,
				zoom   = (screenHeight / PixelwindowHeight) * 0.3,
			}
			rl.BeginMode2D(camera)
			drawAnimation(currentAnimation, playerPosition, playerFlip)
			for platform in platforms {
            	// rl.DrawRectangleRec(platform, rl.RED)
				rl.DrawTextureV(platform_texture, {platform.x, platform.y}, rl.WHITE)
			}
			rl.DrawRectangleRec(playerFeetCollider, {255, 255, 0, 100})
			rl.EndMode2D()
		}
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
