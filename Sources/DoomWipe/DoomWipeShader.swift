/*
 *  DoomWipeShader.swift
 *  Created by Freek (github.com/frzi).
 */

import Metal
import SwiftUI

/// Direction of the wipe effect.
public enum WipeDirection: CGFloat {
	/// The content flows downwards.
	case down = 1
	/// The content flows upwards.
	case up = -1
}

/// Wrapper around SwiftUI's `Shader`.
///
/// Use this to prepare a shader for SwiftUI proper. Use the `.shader` property to access the generated `Shader`.
public struct DoomWipeShader {
	/// The generated SwiftUI `Shader`.
	public let shader: Shader

	/// Initialize a DOOM Wipe shader.
	///
	/// - Parameter dimensions: The width and height of the view the shader will be applied to.
	/// - Parameter animationPosition: The current time position of the animation. 0 = start, 1 = end.`
	/// - Parameter randomOffset: The seed that affects the pattern of the wipe effect.
	/// - Parameter direction: Whether the wipe goes downwards (original), or upwards.
	public init(dimensions: CGSize, animationPosition: CGFloat, randomOffset: Int = 0, direction: WipeDirection) {
		shader = Shader(
			function: ShaderFunction(library: .bundle(.module), name: "doomWipe"),
			arguments: [
				.float2(dimensions), // View dimensions.
				.float2(CGSize(width: 2, height: 2)), // Transition scale.
				.float(min(max(animationPosition, 0), 1)), // Animation position.
				.float(CGFloat(randomOffset)), // Randomness offset.
				.float(direction.rawValue), // Direction (1 = down (original), -1 = up).
			]
		)
	}
}
