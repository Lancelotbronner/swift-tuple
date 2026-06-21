//
//  Swift+.swift
//  swift-tuple
//
//  Created by Christophe Bronner on 2026-01-30.
//

extension IteratorProtocol {
	/// Workaround for https://github.com/swiftlang/swift/issues/69231
	@usableFromInline
	func nextWithoutMutating() -> (next: Element?, mutated: Self) {
		var tmp = self
		return (tmp.next(), tmp)
	}
}

extension Collection {
	@usableFromInline
	subscript(safely position: Index) -> Element? {
		_read {
			if indices.contains(position) {
				yield self[position]
			} else {
				yield nil
			}
		}
	}
}

extension MutableCollection {
	@usableFromInline
	subscript(safely position: Index) -> Element? {
		_read {
			if indices.contains(position) {
				yield self[position]
			} else {
				yield nil
			}
		}
		_modify {
			if indices.contains(position) {
				yield &self[safely: position]
			} else {
				var tmp: Element?
				yield &tmp
			}
		}
	}
}
