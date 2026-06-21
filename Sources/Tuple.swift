//
//  Tuple.swift
//  swift-tuple
//
//  Created by Christophe Bronner on 2025-11-09.
//

import Builtin

/// Provides conditional conformances to standard protocols and allows you to "extend tuples" with your own protocols.
@frozen public struct Tuple<each T> {
	/// The elements of this tuple.
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

public extension Tuple {
	/// The number of elements in this tuple.
	@inlinable var count: Int {
		Int(Builtin.packLength((repeat each T).self))
	}

//	@inlinable subscript(position: Int) -> T {
//		_read {
//			var i = 0
//			for e in repeat each storage {
//				if i == position {
//					yield e
//					return
//				}
//				i += 1
//			}
//		}
//		_modify {
//			var tmp = self[position]
//			yield &tmp
//
//			var i = 0
//			func update<T>(_ previous: T) -> T {
//				defer { i += 1}
//				guard i == position else { return previous }
//				return tmp
//			}
//			storage = (repeat update(each storage))
//		}
//	}
}

extension Tuple: Sendable where repeat each T: Sendable {}
extension Tuple: BitwiseCopyable where repeat each T: BitwiseCopyable {}
extension Tuple: Error where repeat each T: Error {}

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

extension Tuple: CustomDebugStringConvertible {
	public var debugDescription: String {
		let contents = withUnsafeTemporaryAllocation(of: String.self, capacity: count) { buffer in
			buffer.initialize(repeating: "")
			var i = 0
			for e in repeat each storage {
				buffer[i] = String(describing: e)
				i += 1
			}
			return buffer.joined(separator: ", ")
		}
		return "(\(contents))"
	}
}

extension Tuple: CaseIterable where repeat each T: CaseIterable {
	@inlinable public static var allCases: Combination<repeat (each T).AllCases> {
		Combination(repeat (each T).allCases)
	}
}

extension Tuple where repeat each T: Sequence {
	/// Provides a view that iterates elements at the same time.
	@inlinable public var zip: IteratorSequence<ZipIterator<repeat (each T).Iterator>> {
		IteratorSequence(ZipIterator(repeat (each storage).makeIterator()))
	}
}

extension Tuple where repeat each T: Collection {
	/// Provides a collection that iterates the combination of the stored collections.
	@inlinable public var combination: Combination<repeat each T> {
		Combination(repeat each storage)
	}
}
