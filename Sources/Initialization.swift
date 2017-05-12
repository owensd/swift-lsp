/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

import JSONLib

/// The set of parameters that are used for the `initialize` method.
public struct InitializeParams {
    public init(processId: Int? = nil, rootPath: String? = nil, rootUri: DocumentUri? = nil, initializationOptions: Decodable? = nil, capabilities: ClientCapabilities = ClientCapabilities(), trace: TraceSetting? = nil) {
        self.processId = processId
        self.rootPath = rootPath
        self.rootUri = rootUri
        self.initializationOptions = initializationOptions
        self.capabilities = capabilities
        self.trace = trace
    }

	/// The process Id of the parent process that started the server. Is `null` if the process
    /// has not been started by another process.
	/// If the parent process is not alive then the server should exit (see exit notification)
    /// its process.
	public var processId: Int? = nil

	/// The rootPath of the workspace. Is `null` if no folder is open.
	@available(*, deprecated:3.0, message: "The `rootUri` member should be used instead.")
	public var rootPath: String? = nil

	/// The root URI of the workspace. Is `null`` if no folder is open. If both `rootPath` and
    /// `rootUri` are set, `rootUri` wins.
	public var rootUri: DocumentUri? = nil

	/// User provided initialization options.
	public var initializationOptions: Decodable? = nil

	/// The capabilities provided by the client (editor or tool).
	public var capabilities = ClientCapabilities()

	/// The initial trace setting. If omitted trace is disabled ('off').
	public var trace: TraceSetting? = nil
}

/// The response to an `Initialize` request.
public struct InitializeResult {
    public init(capabilities: ServerCapabilities) {
        self.capabilities = capabilities
    }

    /// This should return all of the capabilities that the server supports.
    public var capabilities: ServerCapabilities
}


// MARK: Serialization

extension InitializeParams {
    public static func from(json: JSValue) throws -> InitializeParams {
        guard let _ = json.object else { throw "The `params` value must be a dictionary." }
        let processId = json["processId"].integer ?? nil
        let rootPath = json["rootPath"].string ?? nil
        let rootUri = json["rootUri"].string ?? nil
        // TODO(owensd): Support user options...
        //let initializationOptions = try type(of: initializationOptions).from(json: json["intializationOptions"])
        let initializationOptions: Decodable? = nil
        let capabilities = try ClientCapabilities.from(json: json["capabilities"])
        let trace = try TraceSetting.from(json: json["trace"])

        return InitializeParams(
            processId: processId,
            rootPath: rootPath,
            rootUri: rootUri,
            initializationOptions: initializationOptions,
            capabilities: capabilities,
            trace: trace
        )
    }
}

extension InitializeResult: Encodable {}