# Swift Tuple

An extremely simple solution to conform tuples to protocols.

## Overview

Did you ever want to conform Swift tuples to protocols?

Now you can!

```swift
extension Tuple where repeat each T: MyProtocol {
	func myProtocolRequirement() {
		// ...
	}
}

extension Int: MyProtocol { /* ... */ }
extension String: MyProtocol { /* ... */ }
extension Bool: MyProtocol { /* ... */ }

let test = Tuple(1, "String", false)
test.myProtocolRequirement() // works! :)

test == Tuple(flatten: (1, "String", false)) // true
try JSONEncodable().encode(test) // [1, "String", false]
Tuple(1, 2) < Tuple(0, 560) // false
Set([Tuple(0, "Hello"), Tuple(1, "World!")])
var it = Tuple(["Hello", "World"], [0, 1, 2]).makeIterator()
it.next() == Tuple<String?, Int?>("Hello", 0)
it.next() == Tuple<String?, Int?>("World", 1)
it.next() == Tuple<String?, Int?>(nil, 2)
it.next() == nil
```

`Tuple` conditionally conforms to a number of protocols for your convenience:

- `Equatable`
- `Hashable`
- `BitwiseCopyable`
- `Sendable`
- `Error`
- `Comparable`, with lexicographic ordering
- `Codable`, implemented as an unkeyed container
- `Sequence`, acts as a zip
- `IteratorProtocol`, acts as a zip
- `OptionalProtocol`, transpose into optional

`Tuple` also has additional utilities:

- `count`
- `isAnyNone` and `Tuple` when each elements is ``OptionalProtocol``.
