/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
*/

import JSONLib

/// A general message as defined by JSON-RPC. 
public protocol JsonRpcMessage {
    /// The language server protocol always uses "2.0" as the jsonrpc version.
    var jsonrpc: String { get }
}

/// A request message to describe a request between the client and the server. Every processed
/// request must send a response back to the sender of the request.
public struct RequestMessage<ParamsType: Decodable>: JsonRpcMessage {
    /// The language server protocol always uses "2.0" as the jsonrpc version.
    public let jsonrpc: String = "2.0"

    /// The ID for the given request. This is used to coordinate request/response pairs across the
    /// client and server.
    public var id: RequestId

    /// The language server command method to be invoked.
    public var method: String

    /// The parameters for the message. 
    public var params: ParamsType

    /// Initializes a new `RequestMessage`. 
    public init(id: RequestId, method: String, params: ParamsType) {
        self.id = id
        self.method = method
        self.params = params
    }
}

/// Response Message sent as a result of a request. If a request doesn't provide a result value the
/// receiver of a request still needs to return a response message to conform to the JSON RPC
/// specification. The result property of the ResponseMessage should be set to `null` in this case
/// to signal a successful request.
public struct ResponseMessage: JsonRpcMessage {
    /// The language server protocol always uses "2.0" as the jsonrpc version.
    public let jsonrpc: String = "2.0"

    /// The ID for the given request. This is used to coordinate request/response pairs across the
    /// client and server. This is `null` when there is no associated response ID.
    public var id: RequestId?

    /// The result that is returned back with the response. 
    ///    
    /// NOTE: The spec has this as `result` or `error`, however, this is a deficiency with the type
    /// modelling of TypeScript. There are two possibilities: a result or an error. There is no case
    /// where both `result` and `error` can both have a value or both be `null`.
    public var result: ResponseResult

    /// Create a new response message. It is important that the `id` value match the corresponding
    /// request, otherwise the client/server cannot sync properly.
    public init(id: RequestId? = nil, result: ResponseResult) {
        self.id = id
        self.result = result
    }
}

/// A notification message. A processed notification message must not send a response back. They
/// work like events.
public struct NotificationMessage<ParamsType>: JsonRpcMessage {
    /// The language server protocol always uses "2.0" as the jsonrpc version.
    public let jsonrpc: String = "2.0"

    /// The language server command method to be invoked.
    public var method: String

    /// The paramaters for the message. 
    public var params: ParamsType

    /// Initializes a new `NotificationMessage`. 
    public init(method: String, params: ParamsType) {
        self.method = method
        self.params = params
    }
}

/// A request ID used to coordinate request/response pairs.
public enum RequestId {
    /// The numeric value for the request ID.
    case number(Int)
    /// The string value for the request ID.
    case string(String)
}

/// Any given `ResponseMessage` can either return a result or an error.
public enum ResponseResult {
    /// The result to return back with the response.
    case result(Encodable?)

    /// The error to return back with the response.
    case error(code: Int, message: String, data: Encodable?)
}

// MARK: Serialization

extension RequestId: Decodable {
    public static func from(json: JSValue) throws -> RequestId {
        if let value = json.string {
            return .string(value)
        }
        if let value = json.number {
            return .number(Int(value))
        }

        throw "A request ID must be a string or a number."
    }
}

extension RequestMessage: Decodable {
    public static func from(json: JSValue) throws -> RequestMessage {
        let requestId = try RequestId.from(json: json["requestId"])
        guard let jsonrpc = json["jsonrpc"].string else {
            throw "A request requires a `jsonrpc` member."
        }
        if jsonrpc != "2.0" {
            throw "The only valid value for `jsonrpc` is `2.0`."
        }
        guard let method = json["method"].string else {
            throw "A request requires a `method` member."
        }
        let params = try ParamsType.from(json: json["params"])

        return RequestMessage(id: requestId, method: method, params: params)
    }
}

extension ResponseMessage: Encodable {}
extension ResponseResult: Encodable {
    public func toJson() -> JSValue {
        switch self {
        case let .result(encodable):
            if let encodable = encodable {
                return encodable.toJson()
            }
            return nil
        case let .error(code, message, data):
            var json: JSValue = [:]
            json["code"] = JSValue(Double(code))
            json["message"] = JSValue(message)
            if let data = data {
                json["data"] = data.toJson()
            }
            return json
        }
    }
}

extension RequestId: Encodable {
    public func toJson() -> JSValue {
        switch self {
        case let .number(value): return JSValue(Double(value))
        case let .string(value): return JSValue(value)
        }
    }
}