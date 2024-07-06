package main

import "core:fmt"
import "core:os"
import "core:time"

import rl "vendor:raylib"

import dragon "dragon"

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

	drangonWalk, dragonVelocity, dragonIsGrounded := dragonInit()
	dragonPosition: = rl.Vector2 { -(f32(drangonWalk.texture[0].width) / 2) , -f32(drangonWalk.texture[0].height) }
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

		dragon.dragonController(&dragonPosition, &dragonGrounded, &dragonFlip)
		playerVelocity.y += 1500 * rl.GetFrameTime()
		dragonVelocity.y += 1500 * rl.GetFrameTime()

		if playerGrounded && rl.IsKeyPressed(.UP) {
			playerVelocity.y = -500
		}

		if dragonIsGrounded {

		}

		playerPosition += playerVelocity * rl.GetFrameTime()
		playerFeetCollider := rl.Rectangle{playerPosition.x - 10, playerPosition.y - 4, 20, 4}
		playerGrounded = false

		dragonPosition += dragonVelocity * rl.GetFrameTime()
		dragonFeetCollider := rl.Rectangle{dragonPosition.x + (f32(drangonWalk.texture[0].width) / 2) - 40, dragonPosition.y + f32(drangonWalk.texture[0].height) - 70, 450, 40}
		dragonIsGrounded = false

		for p in platform {
			if rl.CheckCollisionRecs(playerFeetCollider, p.dimensions) &&
			   playerVelocity.y > 0 {
				playerVelocity.y = 0
				playerPosition.y = p.dimensions.y
				playerGrounded = true
			}

			if rl.CheckCollisionRecs(dragonFeetCollider, p.dimensions) &&
				dragonVelocity.y > 0 {
				dragonVelocity.y = 0
				dragonPosition.y = p.dimensions.y - f32(drangonWalk.texture[0].height) + 30
				dragonGrounded = true
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
			drawMultAssetAnimation(drangonWalk, dragonPosition, dragonFlip)

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
