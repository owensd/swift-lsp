/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

import XCTest
@testable import LanguageServerProtocol
@testable import JsonRpcProtocol
import JSONLib

final class EncodableTests: XCTestCase {

    func testEncodable001() {
        let encoded = VersionedTextDocumentIdentifier(uri: "./foo/a.swift", version: 1).encode()
        XCTAssertEqual(encoded["uri"].string, "./foo/a.swift")
        XCTAssertEqual(encoded["version"].integer, 1)
    }

    func testEncodable002() {
        let encoded = CompletionOptions(resolveProvider: true, triggerCharacters: [".", ";"]).encode()
        XCTAssertEqual(encoded["resolveProvider"].bool, true)
        XCTAssertEqual(encoded["triggerCharacters"].array?.first?.string, ".")
        XCTAssertEqual(encoded["triggerCharacters"].array?.last?.string, ";")
    }

    func testEncodable003() {
        let encoded = TextDocumentSyncKind.full.encode()
        XCTAssertEqual(encoded.number, 1)
    }

    func testEncodable004() {
        let diagnostic = Diagnostic(
            range: LanguageServerProtocol.Range(
                start: Position(line: 1, character: 0),
                end: Position(line: 1, character: 10)
            ),
            message: "happy days",
            severity: .warning,
            code: nil,
            source: nil
        )

        let encoded = diagnostic.encode()
        XCTAssertEqual(encoded["range"]["start"]["line"].integer, 1)
        XCTAssertEqual(encoded["range"]["start"]["character"].integer, 0)
        XCTAssertEqual(encoded["range"]["end"]["line"].integer, 1)
        XCTAssertEqual(encoded["range"]["end"]["character"].integer, 10)
        XCTAssertEqual(encoded["severity"].integer, 2)
        XCTAssertTrue(encoded["code"] == nil)
        XCTAssertTrue(encoded["source"] == nil)
        XCTAssertEqual(encoded["message"].string, "happy days")
    }

    static var allTests = [
        ("testEncodable001", testEncodable001),
        ("testEncodable002", testEncodable002),
        ("testEncodable003", testEncodable003),
        ("testEncodable004", testEncodable004),
    ]
}
