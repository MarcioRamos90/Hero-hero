package main

import rl "vendor:raylib"

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


import "core:fmt"

drawMultAssetAnimation :: proc(animation: MulTexturesAnimationStruct, position: rl.Vector2, flip: bool) {

	width := f32(animation.texture[0].width)
	height := f32(animation.texture[0].height)

	currentFrame := u32(rl.GetTime() / animation.frameLength) % animation.numFrames

	currentTexture := animation.texture[currentFrame]

	rl.DrawTextureV(currentTexture, position, rl.WHITE)
}