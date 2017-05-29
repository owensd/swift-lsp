/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

/// A set of pre-defined error codes that can be used when an error occurs.
public enum /*namespace*/ ErrorCodes {
    // Defined by JSON RPC
    static let parseError = -32700
    static let invalidRequest = -32600
    static let methodNotFound = -32601
    static let invalidParams = -32602
    static let internalError = -32603
    static let serverErrorStart = -32099
    static let serverErrorEnd = -32000
    static let serverNotInitialized = -32002
    static let unknownErrorCode = -32001

    // Defined by the protocol.
    static let requestCancelled = -32800
}