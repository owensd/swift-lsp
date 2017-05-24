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

extension Bool: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> Bool {
        guard let value = data.bool else {
            throw "Value is not of type `Bool`."
        }
        return value
    }
}

extension String: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> String {
        guard let value = data.string else {
            throw "Value is not of type `String`."
        }
        return value
    }
}

extension InitializeParams {
    public static func decode(_ data: JSValue?) throws -> InitializeParams {
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
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> TraceSetting {
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
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> RequestId {
        if let value = data.string {
            return .string(value)
        }
        if let value = data.number {
            return .number(Int(value))
        }

        throw "A request ID must be a string or a number."
    }
}

extension CancelParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> CancelParams {
        return CancelParams(id: try RequestId.decode(data["id"]))
    }
}

extension ClientCapabilities: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> ClientCapabilities {
        let workspace = try? WorkspaceClientCapabilities.decode(data["workspace"])
        let textDocument = try? TextDocumentClientCapabilities.decode(data["workspace"])
        
        // TODO(owensd): Support the experimental features.
        let experimental: Any? = nil

        return ClientCapabilities(
            workspace: workspace,
            textDocument: textDocument,
            experimental: experimental)
	}
}

extension TextDocumentClientCapabilities: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> TextDocumentClientCapabilities {
        if let _ = data.object {
            return TextDocumentClientCapabilities()
        }

        throw "The `textDocument` key is not a valid object."
    }
}

extension ShowMessageParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> ShowMessageParams {
        guard let type = try? MessageType.decode(data["type"]) else {
            throw "The `type` parameter is required."
        }
        guard let message = data["message"].string else {
            throw "The `message` parameter is required."
        }

        return ShowMessageParams(type: type, message: message)
    }
}

extension ShowMessageRequestParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> ShowMessageRequestParams {
        guard let type = try? MessageType.decode(data["type"]) else {
            throw "The `type` parameter is required."
        }
        guard let message = data["message"].string else {
            throw "The `message` parameter is required."
        }

        var actions: [MessageActionItem]? = nil
        if let values = data["actions"].array {
            actions = try values.map(MessageActionItem.decode)
        }

        return ShowMessageRequestParams(type: type, message: message, actions: actions)
    }
}

extension LogMessageParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> LogMessageParams {
        guard let type = try? MessageType.decode(data["type"]) else {
            throw "The `type` parameter is required."
        }
        guard let message = data["message"].string else {
            throw "The `message` parameter is required."
        }

        return LogMessageParams(type: type, message: message)
    }
}

extension RegistrationParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> RegistrationParams {
        guard let values = data["registrations"].array else {
            throw "The `registrations` parameter is required."
        }

        let registrations = try values.map(Registration.decode)
        return RegistrationParams(registrations: registrations)
    }
}

extension Registration: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> Registration {
        guard let id = data["id"].string else {
            throw "The `id` parameter is required."
        }
        guard let method = data["method"].string else {
            throw "The `method` parameter is required."
        }

        // TODO(owensd): Handle the registration options

        return Registration(id: id, method: method, registerOptions: nil)
    }
}

extension UnregistrationParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> UnregistrationParams {
        guard let values = data["unregisterations"].array else {
            throw "The `unregisterations` parameter is required."
        }

        let unregisterations = try values.map(Unregistration.decode)
        return UnregistrationParams(unregisterations: unregisterations)
    }
}

extension Unregistration: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> Unregistration {
        guard let id = data["id"].string else {
            throw "The `id` parameter is required."
        }
        guard let method = data["method"].string else {
            throw "The `method` parameter is required."
        }

        return Unregistration(id: id, method: method)
    }
}

extension DidChangeConfigurationParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DidChangeConfigurationParams {
        return DidChangeConfigurationParams(settings: data ?? .null)
    }
}

extension DidChangeWatchedFilesParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DidChangeWatchedFilesParams {
        guard let changes = data["changes"].array else {
            throw "The `changes` property is required."
        }

        let events = try changes.map(FileEvent.decode)
        return DidChangeWatchedFilesParams(changes: events)
    }
}

extension FileEvent: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> FileEvent {
        guard let uri = data["uri"].string else {
            throw "The `uri` parameter is required."
        }

        let type = try FileChangeType.decode(data["type"])
        return FileEvent(uri: uri, type: type)
    }
}

extension FileChangeType: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> FileChangeType {
        guard let number = data.integer else {
            throw "The parameter must be a number."
        }

        guard let type = FileChangeType(rawValue: number) else {
            throw "The value `\(number)` is not a supported change type."
        }

        return type
    }
}

extension WorkspaceSymbolParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> WorkspaceSymbolParams {
        guard let query = data["query"].string else {
            throw "The `query` parameter is required."
        }

        return WorkspaceSymbolParams(query: query)
    }
}

extension ExecuteCommandParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> ExecuteCommandParams {
        guard let command = data["command"].string else {
            throw "The `command` parameter is required."
        }

        var arguments: [String]? = nil
        if let args = data["arguments"].array {
            arguments = args.map { $0.string! }
        }

        return ExecuteCommandParams(command: command, arguments: arguments)
    }
}

extension ApplyWorkspaceEditParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> ApplyWorkspaceEditParams {
        let edit = try WorkspaceEdit.decode(data["edit"])
        return ApplyWorkspaceEditParams(edit: edit)
    }
}

extension WorkspaceEdit: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> WorkspaceEdit {
        if let _ = data["changes"].object {
            throw "The `changes` parameter is not currently implemented."
        }
        else if let documentChanges = data["documentChanges"].array {
            let changes = try documentChanges.map(TextDocumentEdit.decode)
            return .documentChanges(changes)
        }

        throw "A `changes` or `documentChanges` parameter is required."
    }
}

extension TextDocumentEdit: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> TextDocumentEdit {
        let textDocument = try VersionedTextDocumentIdentifier.decode(data["textDocument"])
        guard let values = data["edits"].array else {
            throw "The `edits` parameter is required."
        }
        let edits = try values.map(TextEdit.decode)
        return TextDocumentEdit(textDocument: textDocument, edits: edits)
    }
}

extension TextDocumentIdentifier: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> TextDocumentIdentifier {
        guard let uri = data["uri"].string else {
            throw "The `uri` parameter is required."
        }
        return TextDocumentIdentifier(uri: uri)
    }
}

extension VersionedTextDocumentIdentifier: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> VersionedTextDocumentIdentifier {
        let uri = try TextDocumentIdentifier.decode(data).uri
        guard let version = data["version"].integer else {
            throw "The `version` parameter is required."
        }

        return VersionedTextDocumentIdentifier(uri: uri, version: version)
    }
}

extension TextEdit: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> TextEdit {
        let range = try Range.decode(data["range"])
        guard let newText = data["newText"].string else {
            throw "The `newText` parameter is required."
        }

        return TextEdit(range: range, newText: newText)
    }
}

extension LanguageServerProtocol.Range: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> LanguageServerProtocol.Range {
        let start = try Position.decode(data["start"])
        let end = try Position.decode(data["end"])
        return Range(start: start, end: end)
    }
}

extension Position: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> Position {
        guard let line = data["line"].integer else {
            throw "The `line` parameter is required."
        }
        guard let character = data["character"].integer else {
            throw "The `character` parameter is required."
        }

        return Position(line: line, character: character)
    }
}

extension PublishDiagnosticsParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> PublishDiagnosticsParams {
        guard let uri = data["uri"].string else {
            throw "The `uri` parameter is required."
        }
        guard let values = data["diagnostics"].array else {
            throw "The `diagnostics` parameter is required."
        }
        let diagnostics = try values.map(Diagnostic.decode)
        return PublishDiagnosticsParams(uri: uri, diagnostics: diagnostics)
    }
}

extension Diagnostic: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> Diagnostic {
        let range = try Range.decode(data["range"])
        guard let message = data["message"].string else {
            throw "The `message` parameter is required."
        }

        let severity = try? DiagnosticSeverity.decode(data["severity"])
        let code = try? DiagnosticCode.decode(data["code"])
        let source = data["source"].string

        return Diagnostic(
            range: range,
            message: message,
            severity: severity,
            code: code,
            source: source
        )
    }
}

extension DiagnosticSeverity: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DiagnosticSeverity {
        guard let number = data.integer else {
            throw "The parameter must be an integer."
        }

        guard let severity = DiagnosticSeverity(rawValue: number) else {
            throw "The severity is value is not supported."
        }
        return severity
    }
}

extension DiagnosticCode: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DiagnosticCode {
        if let number = data.integer {
            return .number(number)
        }
        if let string = data.string {
            return .string(string)
        }

        throw "Parameter is not of the expected type."
    }
}

extension DidOpenTextDocumentParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DidOpenTextDocumentParams {
        let textDocument = try TextDocumentItem.decode(data["textDocument"])
        return DidOpenTextDocumentParams(textDocument: textDocument)
    }
}

extension TextDocumentItem: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> TextDocumentItem {
        guard let uri = data["uri"].string else {
            throw "The `uri` parameter is required."
        }

        guard let languageId = data["languageId"].string else {
            throw "The `languageId` parameter is required."
        }

        guard let version = data["version"].integer else {
            throw "The `version` parameter is required."
        }

        guard let text = data["text"].string else {
            throw "The `text` parameter is required."
        }

        return TextDocumentItem(
            uri: uri,
            languageId: languageId,
            version: version,
            text: text
        )
    }
}

extension DidChangeTextDocumentParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DidChangeTextDocumentParams {
        let textDocument = try VersionedTextDocumentIdentifier.decode(data["textDocument"])
        guard let changes = data["contentChanges"].array else {
            throw "The `contentChanges` parameter is required."
        }
        let events = try changes.map(TextDocumentContentChangeEvent.decode)
        return DidChangeTextDocumentParams(
            textDocument: textDocument,
            contentChanges: events
        )
    }
}

extension TextDocumentContentChangeEvent: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> TextDocumentContentChangeEvent {
        guard let text = data["text"].string else {
            throw "The `text` parameter is required."
        }

        let range = try? LanguageServerProtocol.Range.decode(data["range"])
        let rangeLength = data["rangeLength"].integer

        return TextDocumentContentChangeEvent(
            text: text,
            range: range,
            rangeLength: rangeLength
        )
    }
}

extension WillSaveTextDocumentParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> WillSaveTextDocumentParams {
        let textDocument = try TextDocumentIdentifier.decode(data["textDocument"])
        let reason = try TextDocumentSaveReason.decode(data["reason"])

        return WillSaveTextDocumentParams(
            textDocument: textDocument,
            reason: reason
        )
    }
}

extension TextDocumentSaveReason: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> TextDocumentSaveReason {
        guard let value = data.integer else {
            throw "The parameter must be an integer."
        }

        guard let reason = TextDocumentSaveReason(rawValue: value) else {
            throw "The value `\(value)` is not a valid save reason."
        }
        return reason
    }
}

extension DidSaveTextDocumentParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DidSaveTextDocumentParams {
        let textDocument = try TextDocumentIdentifier.decode(data["textDocument"])
        let text = data["text"].string

        return DidSaveTextDocumentParams(
            textDocument: textDocument,
            text: text
        )
    }
}

extension DidCloseTextDocumentParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DidCloseTextDocumentParams {
        let textDocument = try TextDocumentIdentifier.decode(data["textDocument"])
        return DidCloseTextDocumentParams(textDocument: textDocument)
    }
}

extension CompletionItem: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> CompletionItem {
        guard let label = data["label"].string else {
            throw "The `label` parameter is required."
        }

        let kind = try? CompletionItemKind.decode(data["kind"])
        let detail = data["detail"].string
        let documentation = data["documentation"].string
        let sortText = data["sortText"].string
        let filterText = data["filterText"].string
        let insertText = data["insertText"].string
	    let insertTextFormat: InsertTextFormat? = nil
        let textEdit = try? TextEdit.decode(data["textEdit"])

        var additionalEdits: [TextEdit]? = nil
        if let values = data["additionalTextEdits"].array {
            additionalEdits = try values.map(TextEdit.decode)
        }

    	let command = try? Command.decode(data["command"])
        // TODO(owensd): Handle the `data` parameter
        let data: Any? = nil

        return CompletionItem(
            label: label,
            kind: kind,
            detail: detail,
            documentation: documentation,
            sortText: sortText,
            filterText: filterText,
            insertText: insertText,
            insertTextFormat: insertTextFormat,
            textEdit: textEdit,
            additionalTextEdits: additionalEdits,
            command: command,
            data: data
        )
    }
}

extension CompletionItemKind: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> CompletionItemKind {
        guard let number = data.integer else {
            throw "The parameter must be an integer."
        }

        guard let kind = CompletionItemKind(rawValue: number) else {
            throw "The value `\(number)` is not a valid completion kind."
        }
        return kind
    }
}

extension Command: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> Command {
        guard let title = data["title"].string else {
            throw "The `title` parameter is required."
        }

    	guard let command = data["command"].string else {
            throw "The `command` parameter is required."
        }

        let arguments: [String]? = data["arguments"].array?.map { $0.string ?? "" }

        return Command(
            title: title,
            command: command,
            arguments: arguments
        )
    }
}

extension TextDocumentPositionParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> TextDocumentPositionParams {
        let textDocument = try TextDocumentIdentifier.decode(data["textDocument"])
        let position = try Position.decode(data["position"])
        return TextDocumentPositionParams(
            textDocument: textDocument,
            position: position
        )
    }
}

extension ReferenceParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> ReferenceParams {
        let textDocument = try TextDocumentIdentifier.decode(data["textDocument"])
        let position = try Position.decode(data["position"])
        let context = try ReferenceContext.decode(data["context"])
        return ReferenceParams(
            textDocument: textDocument,
            position: position,
            context: context
        )
    }
}

extension ReferenceContext: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> ReferenceContext {
        guard let include = data["includeDeclaration"].bool else {
            throw "The `include` parameter is required."
        }

        return ReferenceContext(includeDeclaration: include)
    }
}

extension DocumentSymbolParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DocumentSymbolParams {
        let textDocument = try TextDocumentIdentifier.decode(data["textDocument"])
        return DocumentSymbolParams(textDocument: textDocument)
    }
}

extension DocumentFormattingParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DocumentFormattingParams {
        let textDocument = try TextDocumentIdentifier.decode(data["textDocument"])
        let options = try FormattingOptions.decode(data["options"])
        return DocumentFormattingParams(
            textDocument: textDocument,
            options: options
        )
    }
}

extension FormattingOptions: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> FormattingOptions {
        guard let tabSize = data["tabSize"].integer else {
            throw "The `tabSize` parameter is required."
        }
        guard let insertSpaces = data["insertSpaces"].bool else {
            throw "The `insertSpaces` parameter is required."
        }

        return FormattingOptions(
            tabSize: tabSize,
            insertSpaces: insertSpaces
        )
    }
}

extension DocumentRangeFormattingParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DocumentRangeFormattingParams {
        let textDocument = try TextDocumentIdentifier.decode(data["textDocument"])
        let range = try LanguageServerProtocol.Range.decode(data["range"])
        let options = try FormattingOptions.decode(data["options"])
        return DocumentRangeFormattingParams(
            textDocument: textDocument,
            range: range,
            options: options
        )
    }
}

extension DocumentOnTypeFormattingParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DocumentOnTypeFormattingParams {
        let textDocument = try TextDocumentIdentifier.decode(data["textDocument"])
        let position = try Position.decode(data["position"])
        guard let ch = data["ch"].string else {
            throw "The `ch` parameter is required."
        }
        let options = try FormattingOptions.decode(data["options"])
        return DocumentOnTypeFormattingParams(
            textDocument: textDocument,
            position: position,
            ch: ch,
            options: options
        )
    }
}

extension CodeActionParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> CodeActionParams {
        let textDocument = try TextDocumentIdentifier.decode(data["textDocument"])
        let range = try LanguageServerProtocol.Range.decode(data["range"])
        let context = try CodeActionContext.decode(data["context"])
        return CodeActionParams(
            textDocument: textDocument,
            range: range,
            context: context
        )
    }
}

extension CodeActionContext: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> CodeActionContext {
        guard let values = data["diagnostics"].array else {
            throw "The `diagnostics` parameter is required."
        }
        return CodeActionContext(
            diagnostics: try values.map(Diagnostic.decode)
        )
    }
}

extension CodeLensParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> CodeLensParams {
        let textDocument = try TextDocumentIdentifier.decode(data["textDocument"])
        return CodeLensParams(textDocument: textDocument)
    }
}

extension CodeLens: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> CodeLens {
        let range = try LanguageServerProtocol.Range.decode(data["range"])
        let command = try? Command.decode(data["command"])
        // TODO(owensd): Parse the any type...
        let data: Any? = nil
        return CodeLens(
            range: range,
            command: command,
            data: data
        )
    }
}

extension DocumentLinkParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DocumentLinkParams {
        let textDocument = try TextDocumentIdentifier.decode(data["textDocument"])
        return DocumentLinkParams(textDocument: textDocument)
    }
}

extension DocumentLink: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DocumentLink {
        return DocumentLink(
            range: try LanguageServerProtocol.Range.decode(data["range"]),
            target: try String.decode(data["target"])
        )
    }
}

extension RenameParams: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> RenameParams {
        return RenameParams(
            textDocument: try TextDocumentIdentifier.decode(data["textDocument"]),
            position: try Position.decode(data["position"]),
            newName: try String.decode(data["newName"])
        )
    }
}

extension MessageType: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> MessageType {
        guard let value = data.integer else {
            throw "The message type must be a number."
        }

        switch value {
        case 1: return .error
        case 2: return .warning
        case 3: return .info
        case 4: return .log
        default: throw "The value '\(value)' is not a supported message type."
        }
    }
}

extension MessageActionItem: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> MessageActionItem {
        return MessageActionItem(title: try String.decode(data["title"]))
    }
}

extension DynamicRegistrationCapability: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DynamicRegistrationCapability {
        return DynamicRegistrationCapability(
            dynamicRegistration: try? Bool.decode(data["dynamicRegistration"]))
    }
}

extension CompletionCapability: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> CompletionCapability {
        return CompletionCapability(
            dynamicRegistration: try? Bool.decode(data["dynamicRegistration"]),
            completionItem: try? CompletionItemCapability.decode(data["completionItem"]))
    }
}

extension CompletionItemCapability: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> CompletionItemCapability {
        return CompletionItemCapability(snippetSupport: try? Bool.decode(data["snippetSupport"]))
    }
}

extension SynchronizationCapability: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> SynchronizationCapability {
        return SynchronizationCapability(
			dynamicRegistration: try? Bool.decode(data["dynamicRegistration"]),
			willSave: try? Bool.decode(data["willSave"]),
			willSaveWaitUntil: try? Bool.decode(data["willSaveWaitUntil"]),
			didSave: try? Bool.decode(data["didSave"]))
    }
}

extension DocumentChangesCapability: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> DocumentChangesCapability {
        return DocumentChangesCapability(documentChanges: try? Bool.decode(data["documentChanges"]))
    }
}

extension WorkspaceClientCapabilities: Decodable {
    public typealias EncodableType = JSValue

    public static func decode(_ data: JSValue?) throws -> WorkspaceClientCapabilities {
        return WorkspaceClientCapabilities(
			applyEdit: try? Bool.decode(data["applyEdit"]),
			workspaceEdit: try? DocumentChangesCapability.decode(data["workspaceEdit"]),
			didChangeConfiguration: try? DynamicRegistrationCapability.decode(data["didChangeConfiguration"]),
			didChangeWatchedFiles: try? DynamicRegistrationCapability.decode(data["didChangeWatchedFiles"]),
			symbol: try? DynamicRegistrationCapability.decode(data["symbol"]),
			executeCommand: try? DynamicRegistrationCapability.decode(data["executeCommand"]))
    }
}
