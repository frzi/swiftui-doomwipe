/*
 *  DoomWipeShader.swift
 *  Created by Freek (github.com/frzi).
 */

import SwiftUI

// MARK: Creating the pattern
/// The original random table from the DOOM source code.
/// [Src](https://github.com/id-Software/DOOM/blob/a77dfb96cb91780ca334d0d4cfd86957558007e0/linuxdoom-1.10/m_random.c)
private let rndtable: [Int] = [
	0, 8, 109, 220, 222, 241, 149, 107, 75, 248, 254, 140, 16, 66,
	74, 21, 211, 47, 80, 242, 154, 27, 205, 128, 161, 89, 77, 36,
	95, 110, 85, 48, 212, 140, 211, 249, 22, 79, 200, 50, 28, 188,
	52, 140, 202, 120, 68, 145, 62, 70, 184, 190, 91, 197, 152, 224,
	149, 104, 25, 178, 252, 182, 202, 182, 141, 197, 4, 81, 181, 242,
	145, 42, 39, 227, 156, 198, 225, 193, 219, 93, 122, 175, 249, 0,
	175, 143, 70, 239, 46, 246, 163, 53, 163, 109, 168, 135, 2, 235,
	25, 92, 20, 145, 138, 77, 69, 166, 78, 176, 173, 212, 166, 113,
	94, 161, 41, 50, 239, 49, 111, 164, 70, 60, 2, 37, 171, 75,
	136, 156, 11, 56, 42, 146, 138, 229, 73, 146, 77, 61, 98, 196,
	135, 106, 63, 197, 195, 86, 96, 203, 113, 101, 170, 247, 181, 113,
	80, 250, 108, 7, 255, 237, 129, 226, 79, 107, 112, 166, 103, 241,
	24, 223, 239, 120, 198, 58, 60, 82, 128, 3, 184, 66, 143, 224,
	145, 224, 81, 206, 163, 45, 63, 90, 168, 114, 59, 33, 159, 95,
	28, 139, 123, 98, 125, 196, 15, 70, 194, 253, 54, 14, 109, 226,
	71, 17, 161, 93, 186, 87, 244, 138, 20, 52, 123, 251, 26, 36,
	17, 46, 52, 231, 232, 76, 31, 221, 84, 37, 216, 165, 212, 106,
	197, 242, 98, 43, 39, 175, 254, 145, 190, 84, 118, 222, 187, 136,
	120, 163, 236, 249
]

/// Creates a `Data` containing normalized offsets of the 'melting' pattern.
private func createPattern(offset: Int = 0) -> Data {
	func random(_ index: Int, _ offset: Int) -> Int {
		return rndtable[(index + offset + 1) & 0xFF]
	}

	// It's a bit of an unorthodox solution, but I want the pattern to be exactly like the original!
	// And there's something to having the exact same code as in the original DOOM source code. :)
	// First create the pattern existing of -15...0.
	var ints = [Int](repeating: 0, count: 256)
	ints[0] = -(random(0, offset) % 16)

	for x in 1 ..< ints.count {
		let r = (random(x, offset) % 3) - 1
		ints[x] = min(max(ints[x - 1] + r, -15), 0)
	}

	// Turn it into an array of normalized floats.
	var floats: [Float] = ints.map { abs(Float($0) / 15.0) }

	return Data(bytes: &floats, count: MemoryLayout<Float>.size * floats.count)
}

// MARK: - Shader
/// Wrapper around SwiftUI's `Shader`.
///
/// Use this to prepare a shader for SwiftUI proper.
/// You can access the generated `Shader` via the `.shader` property.
public struct DoomWipeShader {
	/// Direction of the wipe effect.
	public enum WipeDirection: CGFloat {
		/// The pixels flow downwards.
		case down = 1
		/// The pixels flow upwards.
		case up = -1
	}

	private static var offsetsLookup: [Int : Data] = [:]

	private static func getOffset(seed: Int) -> Data {
		// Keeping a max of 256 different patterns.
		// This means the total used memory will be 256KiB.
		let seed = seed & 0xFF
		offsetsLookup[seed] = offsetsLookup[seed] ?? createPattern(offset: seed)
		return offsetsLookup[seed]!
	}

	/// The generated SwiftUI `Shader`.
	public let shader: Shader

	/// Initialize a DOOM Wipe shader.
	///
	/// - Parameter dimensions: The width and height of the view the shader will be applied to.
	/// - Parameter animationPosition: The current time position of the animation. 0 = start, 1 = end.`
	/// - Parameter seed: The random seed that affects the pattern of the wipe effect.
	/// - Parameter direction: Whether the wipe goes downwards (original), or upwards.
	public init(dimensions: CGSize, animationPosition: CGFloat, seed: Int = 0, direction: WipeDirection) {
		let offsets = Self.getOffset(seed: seed)

		shader = Shader(
			function: ShaderFunction(library: .bundle(.module), name: "doomWipe"),
			arguments: [
				.data(offsets),
				.float2(dimensions), // View dimensions.
				.float2(CGSize(width: 2, height: 2)), // Transition scale.
				.float(min(max(animationPosition, 0), 1)), // Animation position.
				.float(direction.rawValue), // Direction (1 = down (original), -1 = up).
			]
		)
	}
}
