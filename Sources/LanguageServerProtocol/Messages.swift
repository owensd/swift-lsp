/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
*/


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

    /// The parameters for the message. 
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
