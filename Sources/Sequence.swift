//
//  Iterator.swift
//  swift-tuple
//
//  Created by Christophe Bronner on 2026-01-30.
//

extension Tuple: Sequence where repeat each T: Sequence {
	@inlinable public func makeIterator() -> Tuple<repeat (each T).Iterator> {
		.init(repeat (each storage).makeIterator())
	}
}

extension Tuple: IteratorProtocol where repeat each T: IteratorProtocol {
	@inlinable public mutating func next() -> Tuple<repeat (each T).Element?>? {
		let result = (repeat (each storage).nextWithoutMutating())
		let next = Tuple<repeat (each T).Element?>(repeat (each result).next)
		guard !next.isAllNone else { return nil }
		storage = (repeat (each result).mutated)
		return next
	}
}

extension IteratorProtocol {
	/// Workaround for https://github.com/swiftlang/swift/issues/69231
	@usableFromInline
	func nextWithoutMutating() -> (next: Element?, mutated: Self) {
		var tmp = self
		return (tmp.next(), tmp)
	}
}
