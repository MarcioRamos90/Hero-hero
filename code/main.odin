package main

import "core:fmt"
import "core:os"
import rl "vendor:raylib"

Platform :: struct {
	dimensions: rl.Rectangle,
	tilesetmap: rl.Rectangle,
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

	platforms : []Platform = {
		{{-20+(32*0), 20, 32, 32}, {32*1, 32*0, 32, 32}},
		{{-20+(32*1), 20, 32, 32}, {32*2, 32*0, 32, 32}},
		{{-20+(32*2), 20, 32, 32}, {32*2, 32*0, 32, 32}},
		{{-20+(32*3), 20, 32, 32}, {32*2, 32*0, 32, 32}},
		{{-20+(32*4), 20, 32, 32}, {32*2, 32*0, 32, 32}},
		{{-20+(32*5), 20, 32, 32}, {32*2, 32*0, 32, 32}},
		{{-20+(32*6), 20, 32, 32}, {32*2, 32*0, 32, 32}},
		{{-20+(32*7), 20, 32, 32}, {32*2, 32*0, 32, 32}},
		{{-20+(32*8), 20, 32, 32}, {32*2, 32*0, 32, 32}},
		{{-20+(32*9), 20, 32, 32}, {32*2, 32*0, 32, 32}},
	}

	platform_texture := rl.LoadTexture("resources/ground/free_nature_tileset_by_TRA/tileset.png")

	// PLAYER

	playerWalk, playerIdle, playerIdle2, playerJump, playerVelocity, playerPosition, playerFlip, playerGrounded := initilizePlayer()

	currentAnimation: AnimationStruct = playerIdle
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
			if rl.CheckCollisionRecs(playerFeetCollider, platform.dimensions) && playerVelocity.y > 0 {
				playerVelocity.y = 0
				playerPosition.y = platform.dimensions.y
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
				zoom   = (screenHeight / PixelwindowHeight) * 0.2,
			}
			rl.BeginMode2D(camera)
			drawAnimation(currentAnimation, playerPosition, playerFlip)
			for platform in platforms {
            	// rl.DrawRectangleRec(platform, rl.RED)
				rl.DrawTextureRec(platform_texture, {platform.tilesetmap.x, platform.tilesetmap.y, platform.dimensions.width, platform.dimensions.height}, {platform.dimensions.x, platform.dimensions.y}, rl.WHITE)
			}
			rl.DrawRectangleRec(playerFeetCollider, {255, 255, 0, 100})
			rl.EndMode2D()
		}
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
