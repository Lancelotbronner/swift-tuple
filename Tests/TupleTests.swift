//
//  TupleTests.swift
//  swift-tuple
//
//  Created by Christophe Bronner on 2025-11-10.
//

import Foundation
import Testing
import Tuple

@Test func count() {
	#expect(Tuple().count == 0)
	#expect(Tuple(1).count == 1)
	#expect(Tuple(1, 2).count == 2)
	#expect(Tuple(1, 2, 3).count == 3)
}

@Test func equatable() {
	#expect(Tuple(1, "String", false) == Tuple(1, "String", false))
	#expect(Tuple(1, "String", true) != Tuple(1, "String", false))
}

@Test func hashable() {
	let set: Set = [
		Tuple(1, "String", false),
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

@Test func iterator() {
	var it = Tuple(["Hello", "World"], [0, 1, 2]).makeIterator()
	#expect(it.next() == Tuple<String?, Int?>("Hello", 0))
	#expect(it.next() == Tuple<String?, Int?>("World", 1))
	#expect(it.next() == Tuple<String?, Int?>(nil, 2))
	#expect(it.next() == nil)
	#expect(it.next() == nil)
}

@Test func optional() {
	let some = Tuple(Int?.some(2), Int?.some(1))
	#expect(some.isAllNone == false)
	#expect(some.isAnyNone == false)
	#expect(some.asOptional == some)
	let mixed = Tuple(Int?.none, Int?.some(1))
	#expect(mixed.isAllNone == false)
	#expect(mixed.isAnyNone == true)
	#expect(mixed.asOptional == mixed)
	let none = Tuple(Int?.none, String?.none)
	#expect(none.isAllNone == true)
	#expect(none.isAnyNone == true)
	#expect(none.asOptional == nil)
}

@Test func description() {
	let description = Tuple(1, "String", false).debugDescription
	#expect(description == "(1, String, false)")
}

@Test func combination() {
	var it = Tuple(Bit.allCases, Boolean.allCases).combination.makeIterator()
	#expect(it.next() == Tuple(.zero, .false))
	#expect(it.next() == Tuple(.zero, .true))
	#expect(it.next() == Tuple(.one, .false))
	#expect(it.next() == Tuple(.one, .true))
	#expect(it.next() == nil)
	#expect(it.next() == nil)
}

@Test func zip() {
	var it = Tuple([1, 2, 3], [false, true]).longestZip.makeIterator()
	#expect(it.next() == Tuple(Int?.some(1), Bool?.some(false)))
	#expect(it.next() == Tuple(Int?.some(2), Bool?.some(true)))
	#expect(it.next() == Tuple(Int?.some(3), Bool?.none))
	#expect(it.next() == nil)
	#expect(it.next() == nil)
}

@Test func reversed() {
	var it = Tuple(Bit.allCases, Boolean.allCases).combination.reversed().makeIterator()
	#expect(it.next() == Tuple(.one, .true))
	#expect(it.next() == Tuple(.one, .false))
	#expect(it.next() == Tuple(.zero, .true))
	#expect(it.next() == Tuple(.zero, .false))
	#expect(it.next() == nil)
	#expect(it.next() == nil)
}

@Test func memory() {
	print(MemoryLayout<Tuple<UInt8, UInt32, UInt16, UInt64, UInt64, UInt32>>.size)
	print(MemoryLayout<Tuple<UInt8, UInt32, UInt16, UInt64, UInt64, UInt32>>.stride)
	print(MemoryLayout<Tuple<UInt8, UInt32, UInt16, UInt64, UInt64, UInt32>>.alignment)
}

enum Bit: CaseIterable {
	case zero, one
}

enum Boolean: CaseIterable {
	case `false`, `true`
}
