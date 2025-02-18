# CodableDefaults

## **概要**

CodableDefaults は、Swift の `UserDefaults` に対して `Codable` および `NSSecureCoding` に準拠した型を
簡単に保存・取得できる機能を提供するライブラリです。

## **特徴**

- `Codable` に準拠した型を JSON 形式でエンコード／デコードして保存・取得できる
- `NSSecureCoding` に準拠した `NSObject` 派生クラスも安全に扱える
- シンプルで直感的な API を提供

## **使用例**

### Codable 型の使用例

```swift
struct Example: Codable, Equatable {
  let name: String
  let age: Int
}

// 保存例
let example = Example(name: "Taro", age: 30)
UserDefaults.standard.setValue(example, forKey: "exampleKey")

// 取得例（保存されていない場合は default 値が返る）
let storedExample = UserDefaults.standard.value(
  type: Example.self,
  forKey: "exampleKey",
  default: Example(name: "default", age: 0)
)
print(storedExample)
```

### NSSecureCoding 型の使用例

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

// 保存例
let myObject = MyObject(title: "Hello")
UserDefaults.standard.setValue(myObject, forKey: "myObjectKey")

// 取得例（保存されていない場合は default 値が返る）
let storedObject = UserDefaults.standard.value(
  type: MyObject.self,
  forKey: "myObjectKey",
  default: MyObject(title: "Default")
)
print(storedObject.title)
```
