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
    public init(
            workspace: WorkspaceClientCapabilities? = nil,
            textDocument: TextDocumentClientCapabilities? = nil,
            experimental: AnyEncodable? = nil) {
        self.workspace = workspace
        self.textDocument = textDocument
        self.experimental = experimental
    }

    /// Workspace specific client capabilities.
    public var workspace: WorkspaceClientCapabilities?

    /// Text document specific client capabilities.
    public var textDocument: TextDocumentClientCapabilities?

    /// Experimental client capabilities.
    public var experimental: AnyEncodable?
}

/// `TextDocumentClientCapabilities` define capabilities the editor/tool provides on text documents.
public struct TextDocumentClientCapabilities {
    public init(
            synchronization: SynchronizationCapability? = nil,
            completion: CompletionCapability? = nil,
            hover: DynamicRegistrationCapability? = nil,
            signatureHelp: DynamicRegistrationCapability? = nil,
            references: DynamicRegistrationCapability? = nil,
            documentHighlight: DynamicRegistrationCapability? = nil,
            documentSymbol: DynamicRegistrationCapability? = nil,
            formatting: DynamicRegistrationCapability? = nil,
            rangeFormatting: DynamicRegistrationCapability? = nil,
            onTypeFormatting: DynamicRegistrationCapability? = nil,
            definition: DynamicRegistrationCapability? = nil,
            codeAction: DynamicRegistrationCapability? = nil,
            codeLens: DynamicRegistrationCapability? = nil,
            documentLink: DynamicRegistrationCapability? = nil,
            rename: DynamicRegistrationCapability? = nil) {
        self.synchronization = synchronization
        self.completion = completion
        self.hover = hover
        self.signatureHelp = signatureHelp
        self.references = references
        self.documentHighlight = documentHighlight
        self.documentSymbol = documentSymbol
        self.formatting = formatting
        self.rangeFormatting = rangeFormatting
        self.onTypeFormatting = onTypeFormatting
        self.definition = definition
        self.codeAction = codeAction
        self.codeLens = codeLens
        self.documentLink = documentLink
        self.rename = rename
    }

    public var synchronization: SynchronizationCapability?

    /// Capabilities specific to the `textDocument/completion`
    public var completion: CompletionCapability?
    /// Capabilities specific to the `textDocument/hover`
    public var hover: DynamicRegistrationCapability?

    /// Capabilities specific to the `textDocument/signatureHelp`
    public var signatureHelp: DynamicRegistrationCapability?

    /// Capabilities specific to the `textDocument/references`
    public var references: DynamicRegistrationCapability?

    /// Capabilities specific to the `textDocument/documentHighlight`
    public var documentHighlight: DynamicRegistrationCapability?

    /// Capabilities specific to the `textDocument/documentSymbol`
    public var documentSymbol: DynamicRegistrationCapability?

    /// Capabilities specific to the `textDocument/formatting`
    public var formatting: DynamicRegistrationCapability?

    /// Capabilities specific to the `textDocument/rangeFormatting`
    public var rangeFormatting: DynamicRegistrationCapability?

    /// Capabilities specific to the `textDocument/onTypeFormatting`
    public var onTypeFormatting: DynamicRegistrationCapability?

    /// Capabilities specific to the `textDocument/definition`
    public var definition: DynamicRegistrationCapability?

    /// Capabilities specific to the `textDocument/codeAction`
    public var codeAction: DynamicRegistrationCapability?

    /// Capabilities specific to the `textDocument/codeLens`
    public var codeLens: DynamicRegistrationCapability?

    /// Capabilities specific to the `textDocument/documentLink`
    public var documentLink: DynamicRegistrationCapability?

    /// Capabilities specific to the `textDocument/rename`
    public var rename: DynamicRegistrationCapability?
}

public struct SynchronizationCapability {
    public init(
            dynamicRegistration: Bool? = nil,
            willSave: Bool? = nil,
            willSaveWaitUntil: Bool? = nil,
            didSave: Bool? = nil) {
        self.dynamicRegistration = dynamicRegistration
        self.willSave = willSave
        self.willSaveWaitUntil = willSaveWaitUntil
        self.didSave = didSave
    }

    /// Whether text document synchronization supports dynamic registration.
    public var dynamicRegistration: Bool?

    /// The client supports sending will save notifications.
    public var willSave: Bool?

    /// The client supports sending a will save request and waits for a response providing text
    /// edits which will be applied to the document before it is saved.
    public var willSaveWaitUntil: Bool?

    /// The client supports did save notifications.
    public var didSave: Bool?
}

public struct DynamicRegistrationCapability {
    public init(dynamicRegistration: Bool? = nil) {
        self.dynamicRegistration = dynamicRegistration
    }

    public var dynamicRegistration: Bool?
}

public struct CompletionCapability {
    public init(dynamicRegistration: Bool? = nil, completionItem: CompletionItemCapability? = nil) {
        self.dynamicRegistration = dynamicRegistration
        self.completionItem  = completionItem
    }

    public var dynamicRegistration: Bool?
    public var completionItem: CompletionItemCapability?
}

/// Client supports snippets as insert text.
///
/// A snippet can define tab stops and placeholders with `$1`, `$2` and `${3:foo}`. `$0` defines the
/// final tab stop, it defaults to the end of the snippet. Placeholders with equal identifiers are
/// linked, that is typing in one will update others too.
public struct CompletionItemCapability {
    public init(snippetSupport: Bool? = nil) {
        self.snippetSupport = snippetSupport
    }

    public var snippetSupport: Bool?
}

/// `WorkspaceClientCapabilities` define capabilities the editor/tool provides on the workspace:
public struct WorkspaceClientCapabilities {
    public init(
            applyEdit: Bool? = nil,
            workspaceEdit: DocumentChangesCapability? = nil,
            didChangeConfiguration: DynamicRegistrationCapability? = nil,
            didChangeWatchedFiles: DynamicRegistrationCapability? = nil,
            symbol: DynamicRegistrationCapability? = nil,
            executeCommand: DynamicRegistrationCapability? = nil) {
        self.applyEdit = applyEdit
        self.workspaceEdit = workspaceEdit
        self.didChangeConfiguration = didChangeConfiguration
        self.didChangeWatchedFiles = didChangeWatchedFiles
        self.symbol = symbol
        self.executeCommand = executeCommand
    }

    /// The client supports applying batch edits to the workspace by supporting the request
    /// 'workspace/applyEdit'
    public var applyEdit: Bool?

    /// Capabilities specific to `WorkspaceEdit`s
    public var workspaceEdit: DocumentChangesCapability?

    /// Capabilities specific to the `workspace/didChangeConfiguration` notification.
    public var didChangeConfiguration: DynamicRegistrationCapability?

    /// Capabilities specific to the `workspace/didChangeWatchedFiles` notification.
    public var didChangeWatchedFiles: DynamicRegistrationCapability?

    /// Capabilities specific to the `workspace/symbol` request.
    public var symbol: DynamicRegistrationCapability?

    /// Capabilities specific to the `workspace/executeCommand` request.
    public var executeCommand: DynamicRegistrationCapability?
}

public struct DocumentChangesCapability {
    public init(documentChanges: Bool? = nil) {
        self.documentChanges = documentChanges
    }

    /// The client supports versioned document changes in `WorkspaceEdit`s
    public var documentChanges: Bool?
}

public enum TextDocumentSync {
    case options(TextDocumentSyncOptions)
    case kind(TextDocumentSyncKind)
}

public struct ServerCapabilities {
    public init(
            textDocumentSync: TextDocumentSync? = nil,
            hoverProvider: Bool? = nil,
            completionProvider: CompletionOptions? = nil,
            signatureHelpProvider: SignatureHelpOptions? = nil,
            definitionProvider: Bool? = nil,
            referencesProvider: Bool? = nil,
            documentHighlightProvider: Bool? = nil,
            documentSymbolProvider: Bool? = nil,
            workspaceSymbolProvider: Bool? = nil,
            codeActionProvider: Bool? = nil,
            codeLensProvider: CodeLensOptions? = nil,
            documentFormattingProvider: Bool? = nil,
            documentRangeFormattingProvider: Bool? = nil,
            documentOnTypeFormattingProvider: DocumentOnTypeFormattingOptions? = nil,
            renameProvider: Bool? = nil,
            documentLinkProvider: DocumentLinkOptions? = nil,
            executeCommandProvider: ExecuteCommandOptions? = nil,
            experimental: Any? = nil) {
        self.textDocumentSync = textDocumentSync
        self.hoverProvider = hoverProvider
        self.completionProvider = completionProvider
        self.signatureHelpProvider = signatureHelpProvider
        self.definitionProvider = definitionProvider
        self.referencesProvider = referencesProvider
        self.documentHighlightProvider = documentHighlightProvider
        self.documentSymbolProvider = documentSymbolProvider
        self.workspaceSymbolProvider = workspaceSymbolProvider
        self.codeActionProvider = codeActionProvider
        self.codeLensProvider = codeLensProvider
        self.documentFormattingProvider = documentFormattingProvider
        self.documentRangeFormattingProvider = documentRangeFormattingProvider
        self.documentOnTypeFormattingProvider = documentOnTypeFormattingProvider
        self.renameProvider = renameProvider
        self.documentLinkProvider = documentLinkProvider
        self.executeCommandProvider = executeCommandProvider
        self.experimental = experimental
    }

    /// Defines how text documents are synced. Is either a detailed structure defining each
    /// notification or for backwards compatibility the `TextDocumentSyncKind` number.
    public var textDocumentSync: TextDocumentSync? = nil

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
    public init(
            openClose: Bool? = nil,
            change: TextDocumentSyncKind? = nil,
            willSave: Bool? = nil,
            willSaveWaitUntil: Bool? = nil,
            save: SaveOptions? = nil) {
        self.openClose = openClose
        self.change = change
        self.willSave = willSave
        self.willSaveWaitUntil = willSaveWaitUntil
        self.save = save
    }

    /// Open and close notifications are sent to the server.
    public var openClose: Bool?

    /// Change notifications are sent to the server.
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
    public init(includeText: Bool? = nil) {
        self.includeText = includeText
    }

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
    public init(resolveProvider: Bool? = nil, triggerCharacters: [String]? = nil) {
        self.resolveProvider = resolveProvider
        self.triggerCharacters = triggerCharacters
    }

    /// The server provides support to resolve additional information for a completion item.
    public var resolveProvider: Bool?

    /// The characters that trigger completion automatically.
    public var triggerCharacters: [String]?
}

public struct CodeLensOptions {
    public init(resolveProvider: Bool? = nil) {
        self.resolveProvider = resolveProvider
    }

    public var resolveProvider: Bool?
}

public struct SignatureHelpOptions {
    public init(triggerCharacters: [String]? = nil) {
        self.triggerCharacters = triggerCharacters
    }

    public var triggerCharacters: [String]?
}

public struct DocumentOnTypeFormattingOptions {
    public init(trigger: String, moreTriggerCharacter: [String]? = nil) {
        self.firstTriggerCharacter = trigger
        self.moreTriggerCharacter = moreTriggerCharacter
    }

    public var firstTriggerCharacter: String
    public var moreTriggerCharacter: [String]?
}

public struct DocumentLinkOptions {
    public init(resolveProvider: Bool? = nil) {
        self.resolveProvider = resolveProvider
    }

    public var resolveProvider: Bool?
}

public struct ExecuteCommandOptions {
    public init(commands: [String]? = nil) {
        self.commands = commands
    }

    public var commands: [String]?
}
