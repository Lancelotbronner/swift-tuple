//
//  Optional.swift
//  swift-tuple
//
//  Created by Christophe Bronner on 2026-01-30.
//

extension Tuple: OptionalProtocol where repeat each T: OptionalProtocol {
	/// Returns `true` if all elements are `nil`.
	@inlinable public var isAllNone: Bool {
		for opt in repeat each storage {
			if opt.asOptional != nil {
				return false
			}
		}
		return true
	}

	/// Returns `true` if any elements are `nil`.
	@inlinable public var isAnyNone: Bool {
		for opt in repeat each storage {
			if opt.asOptional == nil {
				return true
			}
		}
		return false
	}
	
	/// Returns `nil` if every element is `nil`, itself otherwise.
	@inlinable @_transparent public var asOptional: Tuple? {
		isAllNone ? nil : self
	}
}

/// Helper for Tuple interactions with optionals.
public protocol OptionalProtocol<Wrapped> {
	/// The optional value.
	associatedtype Wrapped
	/// Returns its value as an optional.
	var asOptional: Wrapped? { get }
}

extension Optional: OptionalProtocol {
	@inlinable @_transparent public var asOptional: Wrapped? { self }
}
