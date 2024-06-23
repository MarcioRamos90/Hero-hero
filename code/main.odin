package main

import "core:fmt"
import rl "vendor:raylib"

Vector2 :: rl.Vector2

Vec2_i32 :: struct {
	x: i32,
	y: i32,
}

main :: proc() {
	// -------------------------------------------------------------------------
	//  INITIALIZATING
	// -------------------------------------------------------------------------

	screenWidth: i32 = 1280
	screenHeight: i32 = 720
    
	rl.InitWindow(screenWidth, screenHeight, "Hero hero")
    
	playerVelocity : rl.Vector2

    playerWalkImage := rl.LoadImage("H:\\code\\resources\\swordsman\\Walk.png")
	playerWalkTexture: rl.Texture2D = rl.LoadTextureFromImage(playerWalkImage)
    playerWalkImageCopy := rl.ImageCopy(playerWalkImage)
    playerJumpImage := rl.LoadImage("H:\\code\\resources\\swordsman\\Jump.png")
	playerJumpTexture: rl.Texture2D = rl.LoadTextureFromImage(playerJumpImage)
    playerJumpImageCopy := rl.ImageCopy(playerJumpImage)

    currentTexture : rl.Texture2D = playerWalkTexture
    currentImage := playerWalkImage
    currentImageCopy := playerWalkImageCopy

    player_flip: bool
    player_run_frame_timer: f32
    player_run_frame_length := f32(0.1)
    player_run_current_frame: int

	playerPosition: Vector2 = {f32(0), 320}
    playerGoingToRight := true
    playerGrounded := true

	rl.SetTargetFPS(60)

	currentFrame := 0

	framesCounter := 0
	framesSpeed := 6

    player_run_num_frames := 8

	for !rl.WindowShouldClose() {
		// -------------------------------------------------------------------------
		//  UPDATING
		// -------------------------------------------------------------------------
		if rl.IsKeyPressed(rl.KeyboardKey.RIGHT) || rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
            playerVelocity.x = 400
            player_flip = false
        } else if rl.IsKeyPressed(rl.KeyboardKey.LEFT) || rl.IsKeyDown(rl.KeyboardKey.LEFT) {
            playerVelocity.x = -400
            player_flip = true
        } else {
            playerVelocity.x = 0
        }
		
        playerVelocity.y += 2000 * rl.GetFrameTime()

        if playerGrounded && rl.IsKeyPressed(.UP) {
            playerVelocity.y = -600
            playerGrounded = false
        }

        playerPosition += playerVelocity * rl.GetFrameTime()

        if playerPosition.y > f32(rl.GetScreenHeight() - playerWalkTexture.height) {
            playerPosition.y = f32(rl.GetScreenHeight() - playerWalkTexture.height)
            playerGrounded = true
        }

        if playerGrounded {
            currentTexture = playerWalkTexture
            currentImage := playerWalkImage
            currentImageCopy = playerWalkImageCopy
        } else {
            currentTexture = playerJumpTexture
            currentImage := playerJumpImage
            currentImageCopy = playerJumpImageCopy
        }

        player_run_frame_timer += rl.GetFrameTime()

        if player_run_frame_timer > player_run_frame_length {
            player_run_current_frame += 1
            player_run_frame_timer = 0

            if player_run_current_frame == player_run_num_frames {
                player_run_current_frame = 0
            }
        }

        draw_player_source := rl.Rectangle {
            x = f32(player_run_current_frame) * f32(playerWalkTexture.width) / f32(player_run_num_frames),
            y = 0,
            width = f32(playerWalkTexture.width) / f32(player_run_num_frames),
            height = f32(playerWalkTexture.height),
        }

        if player_flip {
            draw_player_source.width = -draw_player_source.width
        }

        draw_player_dest := rl.Rectangle {
            x = playerPosition.x,
            y = playerPosition.y,
            width = f32(playerWalkTexture.width) / f32(player_run_num_frames),
            height = f32(playerWalkTexture.height)
        }

		// -------------------------------------------------------------------------
		//  DRAWING
		// ----------------------------------------------------------------------------
		rl.BeginDrawing()
		{
            rl.ClearBackground(rl.DARKGRAY)
            // rl.DrawTextureRec(currentTexture, draw_player_source, playerPosition, rl.WHITE)
            rl.DrawTexturePro(currentTexture, draw_player_source, draw_player_dest, 0, 0, rl.WHITE)

		}
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
