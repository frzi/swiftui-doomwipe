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
	float2 scale,
	float value,
	float direction
) {
	const float offsetScale = 0.9;
	const float animationScale = 1.0 + offsetScale;
	value *= animationScale;

	int column = int(position.x / (scale.x * 2)) & 0xFF;
	float offset = offsets[column] * offsetScale;
	offset = min(offset - value, 0.0);
	offset *= direction;

	// Attempt to get normalized 0..1 UV coordinates.
	// We're actually copying `SwiftUI::Layer`'s `sample` method implementation.
	float2 p = metal::fma(position.x, layer.info[0], metal::fma(position.y, layer.info[1], layer.info[2]));
	p = metal::clamp(p, layer.info[3], layer.info[4]);
	p.y += offset;
	half4 color = layer.tex.sample(metal::sampler(metal::filter::linear), p);

	// Alpha = 0 when going out of bounds.
	if (p.y > layer.info[4].y) {
		color.a = 0.0;
	}

	return color;
}
