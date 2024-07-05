package main

import rl "vendor:raylib"

MulTexturesAnimationStruct :: struct {
	texture:      [15]rl.Texture2D,
	numFrames:    u32,
	frameTimer:   f32,
	currentFrame: u32,
	frameLength:  f64,
	name:         Animation_Name,
}



dragonInit :: proc () -> MulTexturesAnimationStruct {
    textures : [15]rl.Texture2D
    textures[0]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_000.png")
    textures[1]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_001.png")
    textures[2]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_002.png")
    textures[3]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_004.png")
    textures[4]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_005.png")
    textures[5]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_006.png")
    textures[6]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_007.png")
    textures[7]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_008.png")
    textures[8]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_009.png")
    textures[9]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_010.png")
    textures[10]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_011.png")
    textures[11]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_012.png")
    textures[12]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_013.png")
    textures[13]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_014.png")
    textures[14]     = rl.LoadTexture("resources\\dragon\\PNG\\Animation\\Dragon1\\Walk_015.png")
    return MulTexturesAnimationStruct {
        texture = textures,
        numFrames   = len(textures),
		frameLength = f64(0.1),
		name        = .Walk,
    }
}