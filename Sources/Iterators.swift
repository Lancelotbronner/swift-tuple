//
//  Iterators.swift
//  swift-tuple
//
//  Created by Christophe Bronner on 2026-06-21.
//

public struct ZipIterator<each T: IteratorProtocol>: IteratorProtocol where repeat each T: IteratorProtocol {
	@usableFromInline var storage: (repeat each T)
	
	@usableFromInline
	init(_ storage: repeat each T) {
		self.storage = (repeat each storage)
	}

	@inlinable
	mutating public func next() -> Tuple<repeat (each T).Element?>? {
		let result = (repeat (each storage).nextWithoutMutating())
		let next = Tuple<repeat (each T).Element?>(repeat (each result).next)
		guard !next.isAllNone else { return nil }
		storage = (repeat (each result).mutated)
		return next
	}
}
