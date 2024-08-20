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

	return color;
}
