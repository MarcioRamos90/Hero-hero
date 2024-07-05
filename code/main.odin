package main

import "core:fmt"
import "core:os"
import "core:time"

import rl "vendor:raylib"

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

	config1 := []StruffStruct {
		{quantity = 1, tileMapPosX = 1, tileMapPosY = 0.},
		{quantity = 200, tileMapPosX = 2, tileMapPosY = 0.},
		{quantity = 1, tileMapPosX = 3, tileMapPosY = 0.},
	}
	platform := tailsetMapGenerator(
		startX = -2000,
		startY = 200,
		width = 32,
		height = 32,
		config = config1,
	)

	platform_texture := rl.LoadTexture("resources/ground/free_nature_tileset_by_TRA/tileset.png")

	// PLAYER

	playerWalk, playerIdle, playerIdle2, playerJump, playerAttack, playerVelocity, playerPosition, playerFlip, playerGrounded :=
		initilizePlayer()

	currentAnimation: AnimationStruct = playerIdle
	rl.SetTargetFPS(60)

	drangon := dragonInit()
	dragonPosition: rl.Vector2
	dragonGrounded := true
	dragonFlip := false

	for !rl.WindowShouldClose() {
		// -------------------------------------------------------------------------
		//  UPDATING
		// -------------------------------------------------------------------------
		if rl.IsKeyDown(rl.KeyboardKey.SPACE) {	
			playerVelocity.x = 0		
			if currentAnimation.name != .Attack_1 {
				currentAnimation = playerAttack
			}
		} else if rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
			playerVelocity.x = 200
			playerFlip = false
			if currentAnimation.name != .Walk {
				currentAnimation = playerWalk
			}
		} else if rl.IsKeyDown(rl.KeyboardKey.LEFT) {
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

		playerFeetCollider := rl.Rectangle{playerPosition.x - 10, playerPosition.y - 4, 20, 4}

		playerGrounded = false

		for p in platform {
			if rl.CheckCollisionRecs(playerFeetCollider, p.dimensions) &&
			   playerVelocity.y > 0 {
				playerVelocity.y = 0
				playerPosition.y = p.dimensions.y
				playerGrounded = true
			}
			dragonPosition.y = (p.dimensions.y * -1) - (f32(drangon.texture[0].height) / 2.7)
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
			drawMultAssetAnimation(drangon, dragonPosition, dragonFlip)
			if currentAnimation.name == .Attack_1 {
				time.sleep(1)
			}
			for p in platform {
				rl.DrawTextureRec(
					platform_texture,
					{
						p.tilesetMap.x,
						p.tilesetMap.y,
						p.dimensions.width,
						p.dimensions.height,
					},
					{p.dimensions.x, p.dimensions.y},
					rl.WHITE,
				)
			}
			rl.EndMode2D()
		}
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
