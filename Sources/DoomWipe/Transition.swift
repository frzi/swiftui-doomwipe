/*
 *  Transition.swift
 *  Created by Freek (github.com/frzi).
 */

import SwiftUI

/// The Doom Wipe transition modifier
///
/// This view modifier composites the view and applies the Doom wipe layer effect.
struct DoomWipeTransitionModifier: ViewModifier {
	private static var globalRandomOffset = 0

	private static func globalAdvancedRandomOffset() -> Int {
		globalRandomOffset += 1
		return globalRandomOffset
	}

	@State private var viewDimensions: CGSize = .zero
	@State private var randomOffset = Self.globalAdvancedRandomOffset()

	var animationPosition: CGFloat = 0
	var direction: DoomWipeShader.WipeDirection = .down

	private var shader: Shader {
		DoomWipeShader(
			dimensions: viewDimensions,
			animationPosition: animationPosition,
			seed: randomOffset,
			direction: direction
		).shader
	}

	func body(content: Content) -> some View {
		content
			.compositingGroup()
			.layerEffect(shader, maxSampleOffset: .zero, isEnabled: true)
			.background(GeometryReader { reader in
				HStack {}
					.onAppear {
						viewDimensions = reader.size
					}
			})
	}
}

extension AnyTransition {
	/// A traditional DOOM wipe transition, where the view 'melts' downwards.
	public static var doomWipe: AnyTransition {
		.asymmetric(
			insertion: .identity,
			removal: .modifier(
				active: DoomWipeTransitionModifier(animationPosition: 1),
				identity: DoomWipeTransitionModifier(animationPosition: 0)
			)
		)
	}

	/// A DOOM wipe transition with a given direction the pixels should flow.
	public static func doomWipe(direction: DoomWipeShader.WipeDirection) -> AnyTransition {
		.asymmetric(
			insertion: .identity,
			removal: .modifier(
				active: DoomWipeTransitionModifier(animationPosition: 1, direction: direction),
				identity: DoomWipeTransitionModifier(animationPosition: 0, direction: direction)
			)
		)
	}
}
