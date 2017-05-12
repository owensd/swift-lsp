/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

import XCTest
@testable import LanguageServerProtocol

final class MessageBufferTests: XCTestCase {
    func testMessageBuffer001() {
        let buffer = MessageBuffer()
        let header = "Content-Length: 133\r\n\r\n"
        let content = "{\"jsonrpc\": \"2.0\", \"id\": 0, \"method\": \"initialize\", \"params\": { \"processId\": 0, \"rootPath\": \"/Users/owensd/foo\", \"capabilities\": {}}}"
        let message = "\(header)\(content)"

        let messages = buffer.write(data: [UInt8](message.data(using: .utf8)!))
        XCTAssertEqual(messages.count, 1)

        if let message = messages.first {
            XCTAssertEqual(message.header.contentLength, 133)
            XCTAssertEqual(message.header.contentType, "application/vscode-jsonrpc; charset=utf-8")
            XCTAssertEqual(String(bytes: message.content, encoding: .utf8)!, content)
        }
        else {
            XCTFail()
        }
    }

    func testMessageBuffer002() {
        let buffer = MessageBuffer()
        let header = "Content-Length: 133\n\n"
        let content = "{\"jsonrpc\": \"2.0\", \"id\": 0, \"method\": \"initialize\", \"params\": { \"processId\": 0, \"rootPath\": \"/Users/owensd/foo\", \"capabilities\": {}}}"
        let message = "\(header)\(content)"

        let messages = buffer.write(data: [UInt8](message.data(using: .utf8)!))
        XCTAssertEqual(messages.count, 1)

        if let message = messages.first {
            XCTAssertEqual(message.header.contentLength, 133)
            XCTAssertEqual(message.header.contentType, "application/vscode-jsonrpc; charset=utf-8")
            XCTAssertEqual(String(bytes: message.content, encoding: .utf8)!, content)
        }
        else {
            XCTFail()
        }
    }

    func testMessageBuffer003() {
        let buffer = MessageBuffer()
        let header = "Content-Length: 133\r\nContent-Type: application/vscode-jsonrpc; charset=utf-16\r\n\r\n"
        let content = "{\"jsonrpc\": \"2.0\", \"id\": 0, \"method\": \"initialize\", \"params\": { \"processId\": 0, \"rootPath\": \"/Users/owensd/foo\", \"capabilities\": {}}}"
        let message = "\(header)\(content)"

        let messages = buffer.write(data: [UInt8](message.data(using: .utf8)!))
        XCTAssertEqual(messages.count, 1)

        if let message = messages.first {
            XCTAssertEqual(message.header.contentLength, 133)
            XCTAssertEqual(message.header.contentType, "application/vscode-jsonrpc; charset=utf-16")
            XCTAssertEqual(String(bytes: message.content, encoding: .utf8)!, content)
        }
        else {
            XCTFail()
        }
    }

    func testMessageBuffer004() {
        let buffer = MessageBuffer()
        let header = "Content-Length: 133\r\n\r\n"
        let content = "{\"jsonrpc\": \"2.0\", \"id\": 0, \"method\": \"initialize\", \"params\": { \"processId\": 0, \"rootPath\": \"/Users/owensd/foo\", \"capabilities\": {}}}"
        let message = "\(header)\(content)\(header)\(content)"

        var messages = buffer.write(data: [UInt8](message.data(using: .utf8)!))
        XCTAssertEqual(messages.count, 2)

        if let message = messages.first {
            XCTAssertEqual(message.header.contentLength, 133)
            XCTAssertEqual(message.header.contentType, "application/vscode-jsonrpc; charset=utf-8")
            XCTAssertEqual(String(bytes: message.content, encoding: .utf8)!, content)
        }
        else {
            XCTFail()
        }

        messages = [Message](messages.dropFirst(1))
        XCTAssertEqual(messages.count, 1)

        if let message = messages.first {
            XCTAssertEqual(message.header.contentLength, 133)
            XCTAssertEqual(message.header.contentType, "application/vscode-jsonrpc; charset=utf-8")
            XCTAssertEqual(String(bytes: message.content, encoding: .utf8)!, content)
        }
        else {
            XCTFail()
        }
    }

    func testMessageBuffer005() {
        let buffer = MessageBuffer()
        let header = "Content-Length: 133\r\n\r\n"
        let content = "{\"jsonrpc\": \"2.0\", \"id\": 0, \"method\": \"initialize\", \"params\": { \"processId\": 0, \"rootPath\": \"/Users/owensd/foo\", \"capabilities\": {}}}"
        
        var messages = buffer.write(data: [UInt8](header.data(using: .utf8)!))
        XCTAssertEqual(messages.count, 0)

        messages = buffer.write(data: [UInt8](content.data(using: .utf8)!))

        if let message = messages.first {
            XCTAssertEqual(message.header.contentLength, 133)
            XCTAssertEqual(message.header.contentType, "application/vscode-jsonrpc; charset=utf-8")
            XCTAssertEqual(String(bytes: message.content, encoding: .utf8)!, content)
        }
        else {
            XCTFail()
        }
    }

    func testMessageBuffer006() {
        let buffer = MessageBuffer()
        let header1 = "Content-Length"
        let header2 = ": 133\r\n\r\n"
        let content = "{\"jsonrpc\": \"2.0\", \"id\": 0, \"method\": \"initialize\", \"params\": { \"processId\": 0, \"rootPath\": \"/Users/owensd/foo\", \"capabilities\": {}}}"

        var messages = buffer.write(data: [UInt8](header1.data(using: .utf8)!))
        XCTAssertEqual(messages.count, 0)

        messages = buffer.write(data: [UInt8](header2.data(using: .utf8)!))
        XCTAssertEqual(messages.count, 0)

        messages = buffer.write(data: [UInt8](content.data(using: .utf8)!))
        XCTAssertEqual(messages.count, 1)

        if let message = messages.first {
            XCTAssertEqual(message.header.contentLength, 133)
            XCTAssertEqual(message.header.contentType, "application/vscode-jsonrpc; charset=utf-8")
            XCTAssertEqual(String(bytes: message.content, encoding: .utf8)!, content)
        }
        else {
            XCTFail()
        }
    }

    func testMessageBuffer007() {
        let buffer = MessageBuffer()
        let header = "Content-Length: 133\r\n\r\n"
        let content1 = "{\"jsonrpc\": \"2.0\", \"id\": 0, \"method\": \"initialize\", \"params\""
        let content2 = ": { \"processId\": 0, \"rootPath\": \"/Users/owensd/foo\", \"capabilities\": {}}}"

        var messages = buffer.write(data: [UInt8](header.data(using: .utf8)!))
        XCTAssertEqual(messages.count, 0)

        messages = buffer.write(data: [UInt8](content1.data(using: .utf8)!))
        XCTAssertEqual(messages.count, 0)
        messages = buffer.write(data: [UInt8](content2.data(using: .utf8)!))
        XCTAssertEqual(messages.count, 1)

        if let message = messages.first {
            XCTAssertEqual(message.header.contentLength, 133)
            XCTAssertEqual(message.header.contentType, "application/vscode-jsonrpc; charset=utf-8")
            XCTAssertEqual(String(bytes: message.content, encoding: .utf8)!, "\(content1)\(content2)")
        }
        else {
            XCTFail()
        }
    }

    static var allTests = [
        ("testMessageBuffer001", testMessageBuffer001),
        ("testMessageBuffer002", testMessageBuffer002),
        ("testMessageBuffer003", testMessageBuffer003),
        ("testMessageBuffer004", testMessageBuffer004),
        ("testMessageBuffer005", testMessageBuffer005),
        ("testMessageBuffer006", testMessageBuffer006),
        ("testMessageBuffer007", testMessageBuffer007),
    ]
}
