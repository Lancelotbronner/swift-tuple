//
//  TupleTests.swift
//  swift-tuple
//
//  Created by Christophe Bronner on 2025-11-10.
//

import Foundation
import Testing
import Tuple

@Suite
struct TupleTests {
	@Test func equatable() {
		#expect(Tuple(1, "String", false) == Tuple(1, "String", false))
		#expect(Tuple(1, "String", true) != Tuple(1, "String", false))
	}

	@Test func hashable() {
		let set: Set = [
			Tuple(1, "String", false),
			Tuple(1, "String", true),
			Tuple(1, "String2", false),
			Tuple(1, "String2", true),
			Tuple(10, "String", false),
			Tuple(10, "String", true),
			Tuple(10, "String2", false),
			Tuple(10, "String2", true),
		]
		#expect(set.count == 8)
	}

	@Test func comparable() {
		// first element matches condition
		#expect(Tuple(0, 1) < Tuple(1, 1))
		#expect(Tuple(1, 1) > Tuple(0, 1))
		// last element matches condition
		#expect(Tuple(1, 0) < Tuple(1, 1))
		#expect(Tuple(1, 1) > Tuple(1, 0))
		// equality doesn't match strict conditions
		#expect(!(Tuple(1, 1) < Tuple(1, 1)))
		#expect(!(Tuple(1, 1) > Tuple(1, 1)))
		// equality matches both conditions
		#expect(Tuple(1, 1) <= Tuple(1, 1))
		#expect(Tuple(1, 1) >= Tuple(1, 1))
	}

	@Test func codable() throws {
		let data = try JSONEncoder().encode(Tuple(1, "String", false))
		let description = String(data: data, encoding: .utf8)
		#expect(description == "[1,\"String\",false]")
		let value = try JSONDecoder().decode(Tuple<Int, String, Bool>.self, from: data)
		#expect(value == Tuple(1, "String", false))
	}
}
