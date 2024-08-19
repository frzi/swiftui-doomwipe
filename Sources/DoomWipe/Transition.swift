/*
 *  Transition.metal
 *  Created by Freek (github.com/frzi).
 */

import Metal
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
	var direction: WipeDirection = .down

	private var shader: Shader {
		DoomWipeShader(
			dimensions: viewDimensions,
			animationPosition: animationPosition,
			randomOffset: randomOffset,
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
//		.modifier(
//			active: DoomWipeTransitionModifier(animationPosition: 1),
//			identity: DoomWipeTransitionModifier(animationPosition: 0)
//		)
	}

	public static func doomWipe(
		direction: WipeDirection = .down,
		randomOffset: CGFloat = 0
	) -> AnyTransition {
		.modifier(
			active: DoomWipeTransitionModifier(animationPosition: 1, direction: direction),
			identity: DoomWipeTransitionModifier(animationPosition: 0, direction: direction)
		)
	}
}