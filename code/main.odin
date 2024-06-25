package main

import "core:fmt"
import "core:os"
import rl "vendor:raylib"

Vector2 :: rl.Vector2

Vec2_i32 :: struct {
	x: i32,
	y: i32,
}

AnimationStruct :: struct {
	texture: rl.Texture2D,
    numFrames: u32,
    frameTimer: f32,
    currentFrame: u32,
    frameLength: f32,
}

main :: proc() {
	// -------------------------------------------------------------------------
	//  INITIALIZATING
	// -------------------------------------------------------------------------

	screenWidth: i32 = 1280
	screenHeight: i32 = 720
    
	rl.InitWindow(screenWidth, screenHeight, "Hero hero")
    
	playerVelocity : rl.Vector2

    playerWalk := AnimationStruct {
        texture = rl.LoadTexture("resources/swordsman/Walk.png"),
        numFrames = 8,
        frameLength = f32(0.1),
    }

    playerIdle := AnimationStruct {
        texture = rl.LoadTexture("resources/swordsman/Idle.png"),
        numFrames = 8,
        frameLength = f32(0.2),
    }

    playerIdle2 := AnimationStruct {
        texture = rl.LoadTexture("resources/swordsman/Idle2.png"),
        numFrames = 3,
        frameLength = f32(0.5),
    }

	playerJumpTexture: rl.Texture2D = rl.LoadTexture("resources/swordsman/Jump.png")

    currentAnimation := playerIdle2

    playerFlip: bool

	playerPosition: Vector2 = {f32(0), 320}
    playerGoingToRight := true
    playerGrounded := true

	rl.SetTargetFPS(60)

	currentFrame := 0

	framesCounter := 0
	framesSpeed := 6


	for !rl.WindowShouldClose() {
		// -------------------------------------------------------------------------
		//  UPDATING
		// -------------------------------------------------------------------------
		if rl.IsKeyPressed(rl.KeyboardKey.RIGHT) || rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
            playerVelocity.x = 400
            playerFlip = false
        } else if rl.IsKeyPressed(rl.KeyboardKey.LEFT) || rl.IsKeyDown(rl.KeyboardKey.LEFT) {
            playerVelocity.x = -400
            playerFlip = true
        } else {
            playerVelocity.x = 0
        }
		
        playerVelocity.y += 2000 * rl.GetFrameTime()

        if playerGrounded && rl.IsKeyPressed(.UP) {
            playerVelocity.y = -600
            playerGrounded = false
        }

        playerPosition += playerVelocity * rl.GetFrameTime()

        if playerPosition.y > f32(rl.GetScreenHeight() - playerWalk.texture.height) {
            playerPosition.y = f32(rl.GetScreenHeight() - playerWalk.texture.height)
            playerGrounded = true
        }

        playerWalk.frameTimer += rl.GetFrameTime()

        if playerWalk.frameTimer > playerWalk.frameLength {
            playerWalk.currentFrame += 1
            playerWalk.frameTimer = 0

            if playerWalk.currentFrame == playerWalk.numFrames {
                playerWalk.currentFrame = 0
            }
        }

        drawPlayerSource := rl.Rectangle {
            x = f32(playerWalk.currentFrame) * f32(playerWalk.texture.width) / f32(playerWalk.numFrames),
            y = 0,
            width = f32(playerWalk.texture.width) / f32(playerWalk.numFrames),
            height = f32(playerWalk.texture.height),
        }

        if playerFlip {
            drawPlayerSource.width = -drawPlayerSource.width
        }

        drawPlayerDest := rl.Rectangle {
            x = playerPosition.x,
            y = playerPosition.y,
            width = f32(playerWalk.texture.width) / f32(playerWalk.numFrames),
            height = f32(playerWalk.texture.height)
        }

		// -------------------------------------------------------------------------
		//  DRAWING
		// ----------------------------------------------------------------------------
		rl.BeginDrawing()
		{
            rl.ClearBackground(rl.DARKGRAY)
            rl.DrawTexturePro(currentAnimation.texture, drawPlayerSource, drawPlayerDest, 0, 0, rl.WHITE)

		}
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
