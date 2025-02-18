# CodableDefaults

## **Overview**

CodableDefaults is a library that provides functionality to easily store and retrieve types conforming to `Codable` and `NSSecureCoding` from Swift's `UserDefaults`.

## **Features**

- Types conforming to `Codable` can be encoded and decoded in JSON format for storage and retrieval  
- Classes derived from `NSObject` that conform to `NSSecureCoding` can also be handled safely  
- Provides a simple and intuitive API

## **Usage Examples**

### Example using a Codable type

```swift
struct Example: Codable, Equatable {
  let name: String
  let age: Int
}

// Saving example
let example = Example(name: "Taro", age: 30)
UserDefaults.standard.setValue(example, forKey: "exampleKey")

// Retrieval example (if not saved, the default value is returned)
let storedExample = UserDefaults.standard.value(
  type: Example.self,
  forKey: "exampleKey",
  default: Example(name: "default", age: 0)
)
print(storedExample)
```

### Example using a NSSecureCoding type

```swift
class MyObject: NSObject, NSSecureCoding {
  static var supportsSecureCoding: Bool { return true }
  
  let title: String
  
  init(title: String) {
    self.title = title
  }
  
  required init?(coder: NSCoder) {
    guard let title = coder.decodeObject(of: NSString.self, forKey: "title") as String? else {
      return nil
    }
    self.title = title
  }
  
  func encode(with coder: NSCoder) {
    coder.encode(title, forKey: "title")
  }
}

// Saving example
let myObject = MyObject(title: "Hello")
UserDefaults.standard.setValue(myObject, forKey: "myObjectKey")

// Retrieval example (if not saved, the default value is returned)
let storedObject = UserDefaults.standard.value(
  type: MyObject.self,
  forKey: "myObjectKey",
  default: MyObject(title: "Default")
)
print(storedObject.title)
```
