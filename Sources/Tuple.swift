//
//  Tuple.swift
//  swift-tuple
//
//  Created by Christophe Bronner on 2025-11-09.
//

/// Provides conditional conformances to standard protocols and allows you to "extend tuples" with your own protocols.
@frozen public struct Tuple<each T> {
	public var storage: (repeat each T)

	/// Initializes a Tuple with its elements.
	///
	/// 	Tuple((1, "2", false))
	/// 	// Tuple<(Int, String, Bool)>
	///
	/// 	Tuple(flatten: (1, "2", false))
	/// 	// Tuple<Int, String, Bool>
	/// - Parameter elements: The elements of the Tuple.
	@inlinable public init(_ elements: repeat each T) {
		self.storage = (repeat each elements)
	}
	
	/// Initializes a Tuple from a regular tuple.
	///
	/// 	Tuple(flatten: (1, "2", false))
	/// 	// Tuple<Int, String, Bool>
	///
	/// 	Tuple((1, "2", false))
	/// 	// Tuple<(Int, String, Bool)>
	/// - Parameter tuple: A regular tuple.
	@inlinable public init(flatten tuple: (repeat each T)) {
		self.storage = tuple
	}
}

extension Tuple: Sendable where repeat each T: Sendable {}
extension Tuple: BitwiseCopyable where repeat each T: BitwiseCopyable {}

extension Tuple: Equatable where repeat each T: Equatable {
	@inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
		for (lhs, rhs) in repeat (each lhs.storage, each rhs.storage) {
			guard lhs == rhs else { return false }
		}
		return true
	}
}

extension Tuple: Hashable where repeat each T: Hashable {
	@inlinable public func hash(into hasher: inout Hasher) {
		for each in repeat each storage {
			hasher.combine(each)
		}
	}
}

extension Tuple: Comparable where repeat each T: Comparable {
	@inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
		for (lhs, rhs) in repeat (each lhs.storage, each rhs.storage) {
			guard lhs == rhs else { return lhs < rhs }
		}
		return false
	}
}

extension Tuple: Decodable where repeat each T: Decodable {
	@inlinable public init(from decoder: any Decoder) throws {
		var container = try decoder.unkeyedContainer()
		storage = (repeat try container.decode((each T).self))
	}
}

extension Tuple: Encodable where repeat each T: Encodable {
	@inlinable public func encode(to encoder: any Encoder) throws {
		var container = encoder.unkeyedContainer()
		repeat try container.encode((each storage).self)
	}
}
