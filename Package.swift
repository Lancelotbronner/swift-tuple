// swift-tools-version: 6.2

import PackageDescription

let package = Package(
	name: "swift-tuple",
	platforms: [
		.macOS(.v14),
	],
	products: [
		.library(name: "swift-tuple", targets: ["Tuple"]),
	],
	targets: [
		.target(name: "Tuple"),
		.testTarget(name: "TupleTests", dependencies: ["Tuple"]),
	]
)
