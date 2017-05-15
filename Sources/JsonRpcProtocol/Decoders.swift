/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

import LanguageServerProtocol

#if os(macOS)
import os.log
#endif

import JSONLib

@available(macOS 10.12, *)
fileprivate let log = OSLog(subsystem: "com.kiadstudios.languageserverprotocol", category: "Serialization")

extension InitializeParams {
    public static func decode(_ data: JSValue) throws -> InitializeParams {
        guard let _ = data.object else { throw "The `params` value must be a dictionary." }
        let processId = data["processId"].integer ?? nil
        let rootPath = data["rootPath"].string ?? nil
        let rootUri = data["rootUri"].string ?? nil
        // TODO(owensd): Support user options...
        //let initializationOptions = try type(of: initializationOptions).decode(json["initializationOptions"])
        let initializationOptions: Any? = nil
        let capabilities = try ClientCapabilities.decode(data["capabilities"])
        let trace = try TraceSetting.decode(data["trace"])

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

extension TraceSetting: Decodable {
	public static func decode(_ data: JSValue) throws -> TraceSetting {
		if !data.hasValue { return .off }
		guard let value = data.string else {
			throw "The trace setting must be a string or not present."
		}
		switch value {
		case "off": return .off
		case "messages": return .messages
		case "verbose": return .verbose
		default: throw "'\(value)' is an unsupported value"
		}
	}
}

extension RequestId: Decodable {
    public static func decode(_ data: JSValue) throws -> RequestId {
        if let value = data.string {
            return .string(value)
        }
        if let value = data.number {
            return .number(Int(value))
        }

        throw "A request ID must be a string or a number."
    }
}

extension RequestMessage: Decodable {
    public static func decode(_ data: JSValue) throws -> RequestMessage {
        let requestId = try RequestId.decode(data["requestId"])
        guard let jsonrpc = data["jsonrpc"].string else {
            throw "A request requires a `jsonrpc` member."
        }
        if jsonrpc != "2.0" {
            throw "The only valid value for `jsonrpc` is `2.0`."
        }
        guard let method = data["method"].string else {
            throw "A request requires a `method` member."
        }
        let params = try ParamsType.decode(data["params"])

        return RequestMessage(id: requestId, method: method, params: params)
    }
}


extension CancelParams: Decodable {
    public static func decode(_ data: JSValue) throws -> CancelParams {
        return CancelParams(id: try RequestId.decode(data["id"]))
    }
}

extension ClientCapabilities: Decodable {
	public static func decode(_ data: JSValue) throws -> ClientCapabilities {
		// TODO(owensd): nyi
		return ClientCapabilities()
	}
}

extension ShowMessageParams: Decodable {
    public static func decode(_ data: JSValue) throws -> ShowMessageParams {
        throw "nyi"
    }
}

extension ShowMessageRequestParams: Decodable {
    public static func decode(_ data: JSValue) throws -> ShowMessageRequestParams {
        throw "nyi"
    }
}

extension LogMessageParams: Decodable {
    public static func decode(_ data: JSValue) throws -> LogMessageParams {
        throw "nyi"
    }
}
extension RegistrationParams: Decodable {
    public static func decode(_ data: JSValue) throws -> RegistrationParams {
        throw "nyi"
    }
}
extension UnregistrationParams: Decodable {
    public static func decode(_ data: JSValue) throws -> UnregistrationParams {
        throw "nyi"
    }
}
extension DidChangeConfigurationParams: Decodable {
    public static func decode(_ data: JSValue) throws -> DidChangeConfigurationParams {
        throw "nyi"
    }
}
extension DidChangeWatchedFilesParams: Decodable {
    public static func decode(_ data: JSValue) throws -> DidChangeWatchedFilesParams {
        throw "nyi"
    }
}
extension WorkspaceSymbolParams: Decodable {
    public static func decode(_ data: JSValue) throws -> WorkspaceSymbolParams {
        throw "nyi"
    }
}
extension ExecuteCommandParams: Decodable {
    public static func decode(_ data: JSValue) throws -> ExecuteCommandParams {
        throw "nyi"
    }
}
extension ApplyWorkspaceEditParams: Decodable {
    public static func decode(_ data: JSValue) throws -> ApplyWorkspaceEditParams {
        throw "nyi"
    }
}
extension PublishDiagnosticsParams: Decodable {
    public static func decode(_ data: JSValue) throws -> PublishDiagnosticsParams {
        throw "nyi"
    }
}
extension DidOpenTextDocumentParams: Decodable {
    public static func decode(_ data: JSValue) throws -> DidOpenTextDocumentParams {
        throw "nyi"
    }
}
extension DidChangeTextDocumentParams: Decodable {
    public static func decode(_ data: JSValue) throws -> DidChangeTextDocumentParams {
        throw "nyi"
    }
}
extension WillSaveTextDocumentParams: Decodable {
    public static func decode(_ data: JSValue) throws -> WillSaveTextDocumentParams {
        throw "nyi"
    }
}
extension DidSaveTextDocumentParams: Decodable {
    public static func decode(_ data: JSValue) throws -> DidSaveTextDocumentParams {
        throw "nyi"
    }
}
extension DidCloseTextDocumentParams: Decodable {
    public static func decode(_ data: JSValue) throws -> DidCloseTextDocumentParams {
        throw "nyi"
    }
}
extension CompletionItem: Decodable {
    public static func decode(_ data: JSValue) throws -> CompletionItem {
        throw "nyi"
    }
}
extension TextDocumentPositionParams: Decodable {
    public static func decode(_ data: JSValue) throws -> TextDocumentPositionParams {
        throw "nyi"
    }
}
extension ReferenceParams: Decodable {
    public static func decode(_ data: JSValue) throws -> ReferenceParams {
        throw "nyi"
    }
}
extension DocumentSymbolParams: Decodable {
    public static func decode(_ data: JSValue) throws -> DocumentSymbolParams {
        throw "nyi"
    }
}
extension DocumentFormattingParams: Decodable {
    public static func decode(_ data: JSValue) throws -> DocumentFormattingParams {
        throw "nyi"
    }
}

extension DocumentRangeFormattingParams: Decodable {
    public static func decode(_ data: JSValue) throws -> DocumentRangeFormattingParams {
        throw "nyi"
    }
}
extension DocumentOnTypeFormattingParams: Decodable {
    public static func decode(_ data: JSValue) throws -> DocumentOnTypeFormattingParams {
        throw "nyi"
    }
}

extension CodeActionParams: Decodable {
    public static func decode(_ data: JSValue) throws -> CodeActionParams {
        throw "nyi"
    }
}

extension CodeLensParams: Decodable {
    public static func decode(_ data: JSValue) throws -> CodeLensParams {
        throw "nyi"
    }
}

extension CodeLens: Decodable {
    public static func decode(_ data: JSValue) throws -> CodeLens {
        throw "nyi"
    }
}

extension DocumentLinkParams: Decodable {
    public static func decode(_ data: JSValue) throws -> DocumentLinkParams {
        throw "nyi"
    }
}

extension DocumentLink: Decodable {
    public static func decode(_ data: JSValue) throws -> DocumentLink {
        throw "nyi"
    }
}

extension RenameParams: Decodable {
    public static func decode(_ data: JSValue) throws -> RenameParams {
        throw "nyi"
    }
}
