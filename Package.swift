// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
		.target(name: "DoomWipe"),
	]
)
