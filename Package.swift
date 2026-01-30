// swift-tools-version: 6.2

import PackageDescription

let package = Package(
	name: "swift-tuple",
	platforms: [
		.macOS(.v14),
		.macCatalyst(.v17),
		.iOS(.v17),
		.tvOS(.v17),
		.watchOS(.v10),
		.visionOS(.v1),
	],
	products: [
		.library(name: "swift-tuple", targets: ["Tuple"]),
	],
	targets: [
		.target(name: "Tuple", swiftSettings: [
			.enableExperimentalFeature("BuiltinModule"),
		]),
		.testTarget(name: "TupleTests", dependencies: ["Tuple"]),
	]
)
