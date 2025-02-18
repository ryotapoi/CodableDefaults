import XCTest
@testable import CodableDefaults

struct CodableValue: Codable, Equatable {
    var name: String
    var age: Int
}

class CodingValue: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool { return true }

    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    required init?(coder: NSCoder) {
        guard let name = coder.decodeObject(of: NSString.self, forKey: "name") as String? else {
            return nil
        }
        self.name = name
        self.age = coder.decodeInteger(forKey: "age")
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(age, forKey: "age")
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? CodingValue else { return false }
        return name == other.name && age == other.age
    }
}

final class UserDefaultCompatibleTests: XCTestCase {

    var ud: UserDefaults!

    override func setUpWithError() throws {
        ud = UserDefaults.standard
        ud.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }

    func testCodableValue() throws {
        let valueType = CodableValue.self
        let testKey = "testKey"
        let expectedDefault = CodableValue(name: "default name", age: 20)
        let newValue = CodableValue(name: "new name", age: 21)

        // 値が保存されていない状態では、default付き取得で期待する値が返る
        let defaultValue = ud.value(type: valueType, forKey: testKey, default: expectedDefault)
        XCTAssertEqual(defaultValue, expectedDefault)

        // 値が未保存の場合は、defaultなし取得でnilとなる
        let unsaved = ud.value(type: valueType, forKey: testKey)
        XCTAssertNil(unsaved)

        // 新しい値を保存して、更新されることを確認する
        ud.setValue(newValue, forKey: testKey)
        let updatedValue = ud.value(type: valueType, forKey: testKey, default: expectedDefault)
        XCTAssertEqual(updatedValue, newValue)

        // 値を削除した後、取得結果がnilとなることを確認する
        ud.setValue(nil, forKey: testKey)
        let removed = ud.value(type: valueType, forKey: testKey)
        XCTAssertNil(removed)
    }

    func testNSCodingValue() throws {
        let valueType = CodingValue.self
        let testKey = "testKey"
        let expectedDefault = CodingValue(name: "default name", age: 20)
        let newValue = CodingValue(name: "new name", age: 21)

        let defaultValue = ud.value(type: valueType, forKey: testKey, default: expectedDefault)
        XCTAssertEqual(defaultValue, expectedDefault)

        let unsaved = ud.value(type: valueType, forKey: testKey)
        XCTAssertNil(unsaved)

        ud.setValue(newValue, forKey: testKey)
        let updatedValue = ud.value(type: valueType, forKey: testKey, default: expectedDefault)
        XCTAssertEqual(updatedValue, newValue)

        ud.setValue(nil, forKey: testKey)
        let removed = ud.value(type: valueType, forKey: testKey)
        XCTAssertNil(removed)
    }

    func testInt() {
        let valueType = Int.self
        let testKey = "testKey"
        let expectedDefault = 1
        let newValue = 2

        let defaultValue = ud.value(type: valueType, forKey: testKey, default: expectedDefault)
        XCTAssertEqual(defaultValue, expectedDefault)

        let unsaved = ud.value(type: valueType, forKey: testKey)
        XCTAssertNil(unsaved)

        ud.setValue(newValue, forKey: testKey)
        let updatedValue = ud.value(type: valueType, forKey: testKey, default: expectedDefault)
        XCTAssertEqual(updatedValue, newValue)

        ud.setValue(nil, forKey: testKey)
        let removed = ud.value(type: valueType, forKey: testKey)
        XCTAssertNil(removed)
    }
}
