/*
 *  DoomWipe.metal
 *  Created by Freek (github.com/frzi).
 */

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]] half4 doomWipe(
	float2 position,
	SwiftUI::Layer layer,
	device const float *offsets,
	int offsetsSize,
	float2 layerSize,
	float2 scale,
	float value,
	float direction
) {
	const float offsetScale = 0.9;
	const float animationScale = 1.0 + offsetScale;
	value *= animationScale;

	int column = int(position.x / (scale.x * 2)) & 0xFF;
	float offset = offsets[column] * offsetScale;
	offset = min((offset * layerSize.y) - (layerSize.y * value), 0.0);
	float y = position.y + offset * direction;

	float2 uv = float2(position.x, y);
	half4 color = layer.sample(uv);

	// Deciphering the actual texture coordinates. This may come useful to later remove `layerSize`.
	// https://stackoverflow.com/a/78687186/4757748
//	position = metal::fma(position.x, layer.info[0], metal::fma(position.y, layer.info[1], layer.info[2]));
//	float width = layer.info[4].x - layer.info[3].x;
//	float height = layer.info[4].y - layer.info[3].y;
//	color = layer.tex.sample(metal::sampler(metal::filter::linear), float2(position.x / width, position.y / height));
//	color = half4(position.x / width, position.y / height, 0.0, 1.0);

	return color;
}
