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
	/// Workspace specific client capabilities.
	public var workspace: WorkspaceClientCapabilities? = nil

	/// Text document specific client capabilities.
	public var textDocument: TextDocumentClientCapabilities? = nil

	/// Experimental client capabilities.
	public var experimental: Any? = nil
}

/// `TextDocumentClientCapabilities` define capabilities the editor/tool provides on text documents.
public struct TextDocumentClientCapabilities {
    // TODO(owensd): fill this in
}

/// `WorkspaceClientCapabilites` define capabilities the editor/tool provides on the workspace:
public struct WorkspaceClientCapabilities {
    // TODO(owensd): fill this in
}

public struct ServerCapabilities {
	/// Defines how text documents are synced. Is either a detailed structure defining each
	/// notification or for backwards compatibility the `TextDocumentSyncKind` number.
	public var textDocumentSync: TextDocumentSyncOptions?

    /// The server provides hover support.
    public var hoverProvider: Bool?

    /// The server provides completion support.
    public var completionProvider: CompletionOptions?

    /// The server provides signature help support.
    public var signatureHelpProvider: SignatureHelpOptions?

    /// The server provides goto definition support.
    public var definitionProvider: Bool?

    /// The server provides find references support.
    public var referencesProvider: Bool?

    /// The server provides document highlight support.
    public var documentHighlightProvider: Bool?

    /// The server provides document symbol support.
    public var documentSymbolProvider: Bool?

    /// The server provides workspace symbol support.
    public var workspaceSymbolProvider: Bool?

    /// The server provides code actions.
    public var codeActionProvider: Bool?

    /// The server provides code lens.
    public var codeLensProvider: CodeLensOptions?

    /// The server provides document formatting.
    public var documentFormattingProvider: Bool?

    /// The server provides document range formatting.
    public var documentRangeFormattingProvider: Bool?

    /// The server provides document formatting on typing.
    public var documentOnTypeFormattingProvider: DocumentOnTypeFormattingOptions?

    /// The server provides rename support.
    public var renameProvider: Bool?

    /// The server provides document link support.
    public var documentLinkProvider: DocumentLinkOptions?

    /// The server provides execute command support.
    public var executeCommandProvider: ExecuteCommandOptions?

    /// Experimental server capabilities.
    public var experimental: Any?
}

public struct TextDocumentSyncOptions {
	/// Open and close notifications are sent to the server.
	public var openClose: Bool?

	/// Change notificatins are sent to the server.
	public var change: TextDocumentSyncKind?

	/// Will save notifications are sent to the server.
	public var willSave: Bool?

	/// Will save wait until requests are sent to the server.
	public var willSaveWaitUntil: Bool?

	/// Save notifications are sent to the server.
	public var save: SaveOptions?
}

/// Save options.
public struct SaveOptions {
	/// The client is supposed to include the content on save.
	public var includeText: Bool?
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
	/// The server provides support to resolve additional information for a completion item.
	public var resolveProvider: Bool?

	/// The characters that trigger completion automatically.
	public var triggerCharacters: [String]?
}

public struct CodeLensOptions {
	public var resolveProvider: Bool?
}

public struct SignatureHelpOptions {
	public var triggerCharacters: [String]?
}

public struct DocumentOnTypeFormattingOptions {
	public var firstTriggerCharacter: String
	public var moreTriggerCharacter: [String]?
}

public struct DocumentLinkOptions {
	public var resolveProvider: Bool?
}

public struct ExecuteCommandOptions {
	public var commands: [String]?
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
