//
//  Combination.swift
//  swift-tuple
//
//  Created by Christophe Bronner on 2026-06-21.
//

/// Enumerates a combination of each underlying collections.
public struct Combination<each T>: Collection where repeat each T: Collection {
	@usableFromInline var storage: (repeat each T)

	@usableFromInline
	init(_ storage: repeat each T) {
		self.storage = (repeat each storage)
	}
}

public extension Combination {
	typealias Index = Tuple<repeat (each T).Index>
	typealias Element = Tuple<repeat (each T).Element>

	@inlinable var startIndex: Index { Index(repeat (each storage).startIndex) }
	@inlinable var endIndex: Index { Index(repeat (each storage).endIndex) }
	@inlinable var count: Int { Tuple(storage).count }

	@inlinable subscript(position: Index) -> Element {
		print("[i]", position)
		return Element(repeat (each storage)[each position.storage])
	}

	@inlinable func index(after i: Index) -> Index {
		print("after", i)
		return withUnsafeTemporaryAllocation(of: Bool.self, capacity: i.count) { buffer in
			var j = 0
			for (next, end) in repeat ((each storage).index(after: each i.storage), (each storage).endIndex) {
				buffer[j] = next == end
				j += 1
			}
			j -= 1
			while buffer[j] {
				j -= 1
				guard j >= 0 else { return endIndex }
			}

			let isDoneBefore = j
			var k = 0

			func apply<I: Comparable>(
				from previous: I,
				to next: I,
				start: I,
				end: I
			) -> I {
				defer { k += 1 }
				let done = k < isDoneBefore
				guard !done else { return previous }
				return buffer[k] ? start : next
			}

			return Index(repeat apply(
				from: each i.storage,
				to: (each storage).index(after: each i.storage),
				start: (each storage).startIndex,
				end: (each storage).endIndex))
		}
	}

	func makeIterator() -> Iterator {
		Iterator(c: self, i: startIndex)
	}

	struct Iterator: IteratorProtocol {
		@usableFromInline let c: Combination
		@usableFromInline var i: Index

		public mutating func next() -> Element? {
			guard i != c.endIndex else { return nil }
			defer { i = c.index(after: i) }
			return c[i]
		}
	}
}

extension Combination: BidirectionalCollection where repeat each T: BidirectionalCollection {
	@inlinable public func index(before i: Index) -> Index {
		print("before", i)
		return withUnsafeTemporaryAllocation(of: Bool.self, capacity: i.count) { buffer in
			var j = 0
			for (previous, start) in repeat (each i.storage, (each storage).startIndex) {
				buffer[j] = previous == start
				j += 1
			}
			j -= 1
			while j >= 0, buffer[j] {
				j -= 1
			}

			let isDoneBefore = j
			var k = 0

			func apply<I: Comparable>(
				from previous: I,
				to next: I,
				reset: I,
				end: I,
			) -> I {
				defer { k += 1 }
				let done = k < isDoneBefore
				print("apply", previous, next, reset, end, buffer[k], done)
				guard !done else { return previous == end ? next : previous }
				return buffer[k] ? reset : next
			}

			return Index(repeat apply(
				from: each i.storage,
				to: (each storage).index(before: each i.storage),
				reset: (each storage).index(before: (each storage).endIndex),
				end: (each storage).endIndex))
		}
	}
}
