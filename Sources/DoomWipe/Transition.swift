/*
 *  Transition.swift
 *  Created by Freek (github.com/frzi).
 */

import AVKit
import SwiftUI

/// The Doom Wipe transition modifier
///
/// This view modifier composites the view and applies the Doom wipe layer effect.
struct DoomWipeTransitionModifier: ViewModifier {
	private static var globalRandomSeed = 0

	private static func globalAdvancedRandomSeed() -> Int {
		globalRandomSeed += 1
		return globalRandomSeed
	}

	@State private var randomSeed = Self.globalAdvancedRandomSeed()

	let progress: CGFloat
	let direction: DoomWipeShader.WipeDirection

	private var shader: Shader {
		DoomWipeShader(
			progress: progress,
			seed: randomSeed,
			direction: direction
		).shader
	}

	init(progress: CGFloat, direction: DoomWipeShader.WipeDirection = .down) {
		self.progress = progress
		self.direction = direction
	}

	func body(content: Content) -> some View {
		content
			.compositingGroup()
			.layerEffect(shader, maxSampleOffset: .zero, isEnabled: true)
	}
}

extension AnyTransition {
	/// A traditional DOOM wipe transition, where the view 'melts' downwards.
	public static var doomWipe: AnyTransition {
		.asymmetric(
			insertion: .identity,
			removal: .modifier(
				active: DoomWipeTransitionModifier(progress: 1),
				identity: DoomWipeTransitionModifier(progress: 0)
			)
		)
	}

	/// A DOOM wipe transition with a given direction the pixels should flow.
	public static func doomWipe(direction: DoomWipeShader.WipeDirection) -> AnyTransition {
		.asymmetric(
			insertion: .identity,
			removal: .modifier(
				active: DoomWipeTransitionModifier(progress: 1, direction: direction),
				identity: DoomWipeTransitionModifier(progress: 0, direction: direction)
			)
		)
	}
}
