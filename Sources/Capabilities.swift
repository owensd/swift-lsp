/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

import JSONLib

/// Client capabilities got introduced with the version 3.0 of the protocol. They therefore only
/// describe capabilities that got introduced in 3.x or later. Capabilities that existed in the 2.x
/// version of the protocol are still mandatory for clients. Clients cannot opt out of providing
/// them. So even if a client omits the `ClientCapabilities.textDocument.synchronization` it is
/// still required that the client provides text document synchronization (e.g. open, changed and
/// close notifications).
public struct ClientCapabilities {
	public init() {}

	/// Workspace specific client capabilities.
	public var workspace: WorkspaceClientCapabilities? = nil

	/// Text document specific client capabilities.
	public var textDocument: TextDocumentClientCapabilities? = nil

	/// Experimental client capabilities.
	public var experimental: Any? = nil
}

/// `TextDocumentClientCapabilities` define capabilities the editor/tool provides on text documents.
public struct TextDocumentClientCapabilities {
	public init() {}
    // TODO(owensd): fill this in
}

/// `WorkspaceClientCapabilities` define capabilities the editor/tool provides on the workspace:
public struct WorkspaceClientCapabilities {
	public init() {}
    // TODO(owensd): fill this in
}

public struct ServerCapabilities {
	public init() {}

	/// Defines how text documents are synced. Is either a detailed structure defining each
	/// notification or for backwards compatibility the `TextDocumentSyncKind` number.
	public var textDocumentSync: TextDocumentSyncOptions? = nil

    /// The server provides hover support.
    public var hoverProvider: Bool? = nil

    /// The server provides completion support.
    public var completionProvider: CompletionOptions? = nil

    /// The server provides signature help support.
    public var signatureHelpProvider: SignatureHelpOptions? = nil

    /// The server provides goto definition support.
    public var definitionProvider: Bool? = nil

    /// The server provides find references support.
    public var referencesProvider: Bool? = nil

    /// The server provides document highlight support.
    public var documentHighlightProvider: Bool? = nil

    /// The server provides document symbol support.
    public var documentSymbolProvider: Bool? = nil

    /// The server provides workspace symbol support.
    public var workspaceSymbolProvider: Bool? = nil

    /// The server provides code actions.
    public var codeActionProvider: Bool? = nil

    /// The server provides code lens.
    public var codeLensProvider: CodeLensOptions? = nil

    /// The server provides document formatting.
    public var documentFormattingProvider: Bool? = nil

    /// The server provides document range formatting.
    public var documentRangeFormattingProvider: Bool? = nil

    /// The server provides document formatting on typing.
    public var documentOnTypeFormattingProvider: DocumentOnTypeFormattingOptions? = nil

    /// The server provides rename support.
    public var renameProvider: Bool? = nil

    /// The server provides document link support.
    public var documentLinkProvider: DocumentLinkOptions? = nil

    /// The server provides execute command support.
    public var executeCommandProvider: ExecuteCommandOptions? = nil

    /// Experimental server capabilities.
    public var experimental: Any? = nil
}

public struct TextDocumentSyncOptions {
	public init() {}

	/// Open and close notifications are sent to the server.
	public var openClose: Bool? = nil

	/// Change notifications are sent to the server.
	public var change: TextDocumentSyncKind? = nil

	/// Will save notifications are sent to the server.
	public var willSave: Bool? = nil

	/// Will save wait until requests are sent to the server.
	public var willSaveWaitUntil: Bool? = nil

	/// Save notifications are sent to the server.
	public var save: SaveOptions? = nil
}

/// Save options.
public struct SaveOptions {
	public init() {}

	/// The client is supposed to include the content on save.
	public var includeText: Bool? = nil
}

/// Defines how the host (editor) should sync document changes to the language server.
public enum TextDocumentSyncKind: Int {
    /// Documents should not be synced at all.
	case none = 0

	/// Documents are synced by always sending the full content of the document.
	case full = 1

	/// Documents are synced by sending the full content on open. After that only incremental
	/// updates to the document are send.
	case incremental = 2
}

/// The options to dictate how completion triggers should work.
public struct CompletionOptions {
	public init() {}

	/// The server provides support to resolve additional information for a completion item.
	public var resolveProvider: Bool? = nil

	/// The characters that trigger completion automatically.
	public var triggerCharacters: [String]? = nil
}

public struct CodeLensOptions {
	public init() {}

	public var resolveProvider: Bool? = nil
}

public struct SignatureHelpOptions {
	public init() {}

	public var triggerCharacters: [String]? = nil
}

public struct DocumentOnTypeFormattingOptions {
	public init(trigger: String) {
		self.firstTriggerCharacter = trigger
	}

	public var firstTriggerCharacter: String
	public var moreTriggerCharacter: [String]? = nil
}

public struct DocumentLinkOptions {
	public init() {}

	public var resolveProvider: Bool? = nil
}

public struct ExecuteCommandOptions {
	public init() {}

	public var commands: [String]? = nil
}


// MARK: Serialization

extension ClientCapabilities: Decodable {
	public static func from(json: JSValue) throws -> ClientCapabilities {
		// TODO(owensd): nyi
		return ClientCapabilities()
	}
}

extension ServerCapabilities: Encodable {}
extension TextDocumentSyncOptions: Encodable {}

extension TextDocumentSyncKind: Encodable {
	public func toJson() -> JSValue {
		return JSValue(Double(self.rawValue))
	}
}

extension CompletionOptions: Encodable {
	public func toJson() -> JSValue {
		var json: JSValue = [:]
		if let provider = self.resolveProvider {
			json["resolveProvider"] = JSValue(provider)
		}

		if let triggers = self.triggerCharacters {
			json["triggerCharacters"] = JSValue(triggers.joined(separator: ", "))
		}

		return json
	}
}

extension CodeLensOptions: Encodable {}

extension SignatureHelpOptions: Encodable {
	public func toJson() -> JSValue {
		var json: JSValue = [:]
		if let triggers = self.triggerCharacters {
			json["triggerCharacters"] = JSValue(triggers.joined(separator: ", "))
		}

		return json
	}
}

extension DocumentOnTypeFormattingOptions: Encodable {}
extension DocumentLinkOptions: Encodable {}
extension ExecuteCommandOptions: Encodable {}
