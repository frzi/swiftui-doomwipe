// swift-tools-version: 5.10

import PackageDescription

let package = Package(
	name: "DoomWipe",
	platforms: [
		.iOS(.v17),
		.macOS(.v14),
		.tvOS(.v17),
		.visionOS(.v1),
	],
	products: [
		.library(
			name: "DoomWipe",
			targets: ["DoomWipe"]),
	],
	targets: [
		.target(
			name: "DoomWipe",
			resources: [
				.process("Resources/DoomWipe.metal")
			]
		),
	]
)
