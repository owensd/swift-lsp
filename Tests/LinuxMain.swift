import XCTest
@testable import LanguageServerProtocolTests
@testable import JsonRpcProtocolTests

XCTMain([
    testCase(MessageBufferTests.allTests),
    testCase(EncodableTests.allTests),
])
