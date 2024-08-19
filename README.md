<img src="Misc/readme-title.png" alt="Doom Wipe transition for SwiftUI" width="726px">

![SwiftUI](https://img.shields.io/github/v/release/frzi/swiftui-doomwipe?style=for-the-badge)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-blue.svg?style=for-the-badge&logo=swift&logoColor=black)](https://developer.apple.com/xcode/swiftui)
[![Swift](https://img.shields.io/badge/Swift-5.10-orange.svg?style=for-the-badge&logo=swift)](https://swift.org)
[![MIT](https://img.shields.io/badge/license-MIT-black.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A transition for your SwiftUI views that simulates the 1993 classic DOOM screen wipe (the melting effect, you know the one!)

<img src="Misc/demo.gif" alt="Demonstration">

> [!IMPORTANT]  
> This transition utilizes SwiftUI 5's [.layerEffect](https://developer.apple.com/documentation/swiftui/view/layereffect(_:maxsampleoffset:isenabled:)). AppKit/UIKit powered views will *not* work. This includes views like `TextField`.

## How to use
Use it like any other transition:
```swift
MyView()
	.transition(.doomWipe)
```

Additionally, you can initialize a `Shader` with custom parameters to setup your own transitions. Or to apply the `.layerEffect` wherever.
```swift
let doomWipe = DoomWipeShader(
	dimensions: viewDimensions,
	animationPosition: time,
	direction: .down
)
let shader: Shader = doomWipe.shader
```

## License
[MIT License](LICENSE).