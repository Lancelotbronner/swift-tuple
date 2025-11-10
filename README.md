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
```

`Tuple` conditionally conforms to a number of protocols for your convenience, such as `Equatable`, `Hashable`, `Comparable` and `Codable`.
