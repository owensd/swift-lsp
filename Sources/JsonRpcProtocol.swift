/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

import JSONLib

#if os(macOS)
import os.log
#endif

@available(macOS 10.12, *)
fileprivate let log = OSLog(subsystem: "com.kiadstudios.languageserverprotocol", category: "JsonRpcProtocol")

/// This provides the complete implementation necessary to translate an incoming message to a
/// `LanguageServiceCommand`.
public final class JsonRpcProtocol: MessageProtocol {
    /// The registration table for all of the commands that can be handled via this protocol.
    public var protocols: [String:(JSValue) throws -> LanguageServerCommand] = [:]

    /// Creates a new instance of the `LanguageServerProtocol`.
    public init() {
        protocols["initialize"] = general(initialize:)
        protocols["initialized"] = general(initialized:)
        protocols["shutdown"] = general(shutdown:)
        protocols["exit"] = general(exit:)
        protocols["$/cancelRequest"] = general(cancelRequest:)

        protocols["window/showMessage"] = window(showMessage:)
        protocols["window/showMessageRequest"] = window(showMessageRequest:)
        protocols["window/logMessage"] = window(logMessage:)
        protocols["telemetry/event"] = telemetry(event:)

        protocols["client/registerCapability"] = client(registerCapability:)
        protocols["client/unregisterCapability"] = client(unregisterCapability:)

        protocols["workspace/didChangeConfiguration"] = workspace(didChangeConfiguration:)
        protocols["workspace/didChangeWatchedFiles"] = workspace(didChangeWatchedFiles:)
        protocols["workspace/symbol"] = workspace(symbol:)
        protocols["workspace/executeCommand"] = workspace(executeCommand:)
        protocols["workspace/applyEdit"] = workspace(applyEdit:)

        protocols["textDocument/publishDiagnostics"] = textDocument(publishDiagnostics:)
        protocols["textDocument/didOpen"] = textDocument(didOpen:)
        protocols["textDocument/didChange"] = textDocument(didChange:)
        protocols["textDocument/willSave"] = textDocument(willSave:)
        protocols["textDocument/willSaveWaitUntil"] = textDocument(willSaveWaitUntil:)
        protocols["textDocument/didSave"] = textDocument(didSave:)
        protocols["textDocument/didClose"] = textDocument(didClose:)
        protocols["textDocument/completion"] = textDocument(completion:)
        protocols["completionItem/resolve"] = completionItem(resolve:)
        protocols["textDocument/hover"] = textDocument(hover:)
        protocols["textDocument/signatureHelp"] = textDocument(signatureHelp:)
        protocols["textDocument/references"] = textDocument(references:)
        protocols["textDocument/documentHighlight"] = textDocument(documentHighlight:)
        protocols["textDocument/documentSymbol"] = textDocument(documentSymbol:)
        protocols["textDocument/formatting"] = textDocument(formatting:)
        protocols["textDocument/rangeFormatting"] = textDocument(rangeFormatting:)
        protocols["textDocument/onTypeFormatting"] = textDocument(onTypeFormatting:)
        protocols["textDocument/definition"] = textDocument(definition:)
        protocols["textDocument/codeAction"] = textDocument(codeAction:)
        protocols["textDocument/codeLens"] = textDocument(codeLens:)
        protocols["codeLens/resolve"] = codeLens(resolve:)
        protocols["textDocument/documentLink"] = textDocument(documentLink:)
        protocols["documentLink/resolve"] = documentLink(resolve:)
        protocols["textDocument/rename"] = textDocument(rename:)
    }

    /// This is used to convert the raw incoming message to a `LanguageServerCommand`. The internals
    /// handle the JSON-RPC mechanism, but that doesn't need to be exposed.
    public func translate(message: Message) throws-> LanguageServerCommand {
        guard let json = JSValue.parse(message.content).value else {
            throw "unable to parse the incoming message"
        }
            
        if json["jsonrpc"] != "2.0" {
            throw "The only 'jsonrpc' value supported is '2.0'."
        }

        guard let method = json["method"].string else {
            throw "A message is required to have a `method` parameter."
        }

        if let parser = protocols[method] {
            return try parser(json)
        }
        else {
            throw "unhandled method `\(method)`"
        }
    }

    /// Translates the response into a raw `MessageData`. This function can throw, providing detailed
    /// error information about why the transformation could not be done.
    public func translate(response: ResponseMessage) throws -> MessageData {
        let json = response.toJson().stringify(nil)                        
        let contentLength = json.characters.count
        let header = "Content-Length: \(contentLength)\r\nContent-Type: application/vscode-jsonrpc; charset=utf8\r\n\r\n"
        let message = "\(header)\(json)"

        guard let data = message.data(using: .utf8) else {
            throw "unable to convert the response to data"
        }

        return [UInt8](data)
    }

    private func general(initialize json: JSValue) throws -> LanguageServerCommand {
        return .initialize(
            requestId: try RequestId.from(json: json["id"]),
            params: try InitializeParams.from(json: json["params"]))
    }

    private func general(initialized json: JSValue) throws -> LanguageServerCommand {
        return .initialized(requestId: try RequestId.from(json: json["id"]))
    }

    private func general(shutdown json: JSValue) throws -> LanguageServerCommand {
        return .shutdown(requestId: try RequestId.from(json: json["id"]))
    }

    private func general(exit json: JSValue) throws -> LanguageServerCommand {
        return .exit(requestId: try RequestId.from(json: json["id"]))
    }

    private func general(cancelRequest json: JSValue) throws -> LanguageServerCommand {
        return .cancelRequest(
            requestId: try RequestId.from(json: json["id"]),
            params: try CancelParams.from(json: json["params"]))
    }

    private func window(showMessage json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func window(showMessageRequest json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func window(logMessage json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func telemetry(event json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func client(registerCapability json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func client(unregisterCapability json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func workspace(didChangeConfiguration json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func workspace(didChangeWatchedFiles json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func workspace(symbol json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func workspace(executeCommand json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func workspace(applyEdit json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(publishDiagnostics json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(didOpen json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(didChange json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(willSave json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(willSaveWaitUntil json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(didSave json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(didClose json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(completion json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func completionItem(resolve json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(hover json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(signatureHelp json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(references json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(documentHighlight json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(documentSymbol json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(formatting json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(rangeFormatting json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(onTypeFormatting json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(definition json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(codeAction json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(codeLens json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func codeLens(resolve json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(documentLink json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func documentLink(resolve json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }

    private func textDocument(rename json: JSValue) throws -> LanguageServerCommand {
        throw "nyi"
    }
}
