package main

import rl "vendor:raylib"

PlatformPiece :: struct {
	dimensions: rl.Rectangle,
	tilesetMap: rl.Rectangle,
}

StruffStruct :: struct {
	quantity:    int,
	tileMapPosX: f32,
	tileMapPosY: f32,
}

tailsetMapGenerator :: proc(
	startX: f32,
	startY: f32,
	width: f32,
	height: f32,
	config: []StruffStruct,
) -> [dynamic]PlatformPiece {

	tailsetMap: [dynamic]PlatformPiece
	prevRange := 0
	for j := 0; j < len(config); j += 1 {
		for i := 0; i < config[j].quantity; i += 1 {
			append(
				&tailsetMap,
				PlatformPiece {
					dimensions = {
						x = startX + width * f32(prevRange + i),
						y = startY,
						width = width,
						height = height,
					},
					tilesetMap = {
						config[j].tileMapPosX * 32,
						config[j].tileMapPosY * 32,
						width,
						height,
					},
				},
			)
		}
		prevRange += config[j].quantity
	}
	return tailsetMap
}