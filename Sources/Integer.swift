//
//  Integer.swift
//  swift-tuple
//
//  Created by Christophe Bronner on 2026-06-21.
//

// this is fun
func add<each I: FixedWidthInteger>(lhs: repeat each I, rhs: repeat each I) -> (repeat each I) {
	var carry = false
	func add<T: FixedWidthInteger>(lhs: T, rhs: T) -> T {
		let r1 = lhs.addingReportingOverflow(rhs)
		let r2 = r1.partialValue.addingReportingOverflow(carry ? 1 : 0)
		carry = r1.overflow || r2.overflow
		return r2.partialValue
	}
	return (repeat add(lhs: each lhs, rhs: each rhs))
}
