/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

import XCTest
@testable import LanguageServerProtocol
@testable import JsonRpcProtocol

final class EncodableTests: XCTestCase {

    func testEncodable001() {
        struct Foo: Encodable {
            let name: String
            let age: Int
        }

        let encoded = Foo(name: "David", age: 35).encode()
        XCTAssertEqual(encoded["name"].string, "David")
        XCTAssertEqual(encoded["age"], 35)
    }

    func testEncodable002() {
        struct Foo: Encodable {
            let name: String
            let age: Int
            let children: [String]
        }

        let encoded = Foo(name: "David", age: 35, children: ["Natalie"]).encode()
        XCTAssertEqual(encoded["name"].string, "David")
        XCTAssertEqual(encoded["age"], 35)
        XCTAssertEqual(encoded["children"].array?.first?.string, "Natalie")
    }

    func testEncodable003() {
        struct Bar: Encodable {
            let message: String
        }

        struct Foo: Encodable {
            let name: String
            let age: Int
            let children: [String]
            let other: Bar? = nil
        }

        let encoded = Foo(name: "David", age: 35, children: ["Natalie"]).encode()
        XCTAssertEqual(encoded["name"].string, "David")
        XCTAssertEqual(encoded["age"], 35)
        XCTAssertEqual(encoded["children"].array?.first?.string, "Natalie")
        XCTAssertEqual(encoded["other"].hasValue, false)
    }

    func testEncodable004() {
        struct Bar: Encodable {
            let message: String
        }

        struct Foo: Encodable {
            let name: String
            let age: Int
            let children: [String]
            let other: Bar?
        }

        let encoded = Foo(name: "David", age: 35, children: ["Natalie"], other: Bar(message: "hello!")).encode()
        XCTAssertEqual(encoded["name"].string, "David")
        XCTAssertEqual(encoded["age"], 35)
        XCTAssertEqual(encoded["children"].array?.first?.string, "Natalie")
        XCTAssertEqual(encoded["other"]["message"].string, "hello!")
    }

    func testEncodable005() {
        struct Bar: Encodable {
            let message: String
        }

        struct Foo: Encodable {
            let name: String
            let age: Int
            let children: [String]
            let other: [Bar]?
        }

        let encoded = Foo(name: "David", age: 35, children: ["Natalie"], other: [Bar(message: "hello"), Bar(message: "world!")]).encode()
        XCTAssertEqual(encoded["name"].string, "David")
        XCTAssertEqual(encoded["age"], 35)
        XCTAssertEqual(encoded["children"].array?.first?.string, "Natalie")
        XCTAssertEqual(encoded["other"].array?.first?["message"].string, "hello")
        XCTAssertEqual(encoded["other"].array?.last?["message"].string, "world!")
    }

    static var allTests = [
        ("testEncodable001", testEncodable001),
        ("testEncodable002", testEncodable002),
        ("testEncodable003", testEncodable003),
        ("testEncodable004", testEncodable004),
        ("testEncodable005", testEncodable005),
    ]
}