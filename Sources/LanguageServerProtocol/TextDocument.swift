/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

/// TODO(owensd): Properly implement this according to the spec.
public typealias DocumentUri = String

/// Position in a text document expressed as zero-based line and character offset. A position is
/// between two characters like an 'insert' cursor in a editor.
public struct Position {
	public init(line: Int, character: Int) {
		self.line = line
		self.character = character
	}

    /// Line position in a document (zero-based).
    public var line: Int

    /// Character offset on a line in a document (zero-based).
    public var character: Int
}

/// A range in a text document expressed as (zero-based) start and end positions. A range is
/// comparable to a selection in an editor. Therefore the end position is exclusive.
public struct Range {
	public init(start: Position, end: Position) {
		self.start = start
		self.end = end
	}

    /// The range's start position.
    public var start: Position

    /// The range's end position.
    public var end: Position
}

/// Represents a location inside a resource, such as a line inside a text file.
public struct Location {
	public init(uri: DocumentUri, range: Range) {
		self.uri = uri
		self.range = range
	}

    /// The URI of the document the location belongs to.
	public var uri: DocumentUri

    /// The full range that should make up the range.
	public var range: Range
}

/// A textual edit applicable to a text document.
///
/// If multiple TextEdits are applied to a text document, all text edits describe changes made to
/// the initial document version. Execution wise text edits should applied from the bottom to the
/// top of the text document. Overlapping text edits are not supported.
public struct TextEdit {
	public init(range: Range, newText: String) {
		self.range = range
		self.newText = newText
	}

	/// The range of the text document to be manipulated. To insert text into a document create
    /// a range where `start === end`.
	public var range: Range

	/// The string to be inserted. For delete operations use an empty string.
	public var newText: String
}

/// Describes textual changes on a single text document. The text document is referred to as a
/// `VersionedTextDocumentIdentifier` to allow clients to check the text document version before an
/// edit is applied.
public struct TextDocumentEdit {
	public init(textDocument: VersionedTextDocumentIdentifier, edits: [TextEdit]) {
		self.textDocument = textDocument
		self.edits = edits
	}

	/// The text document to change.
	public var textDocument: VersionedTextDocumentIdentifier

    /// The edits to be applied.
	public var edits: [TextEdit]
}

/// A workspace edit represents changes to many resources managed in the workspace. The edit should
/// either provide `changes` or `documentChanges`. If `documentChanges` are present they are
/// preferred over changes if the client can handle versioned document edits.
public enum WorkspaceEdit {
	/// Holds changes to existing resources.
    case changes([DocumentUri:[TextEdit]])

	/// An array of `TextDocumentEdit`s to express changes to specific a specific version of a text
	/// document. Whether a client supports versioned document edits is expressed via
	/// `WorkspaceClientCapabilities.versionedWorkspaceEdit`.
	case documentChanges([TextDocumentEdit])
}

/// Text documents are identified using a URI. On the protocol level, URIs are passed as strings.
/// The corresponding JSON structure looks like this:
public struct TextDocumentIdentifier {
    /// The text document's URI.
	public var uri: DocumentUri

    public init(uri: DocumentUri) {
        self.uri = uri
    }
}

/// An item to transfer a text document from the client to the server.
public struct TextDocumentItem {
	public init(uri: DocumentUri, languageId: String, version: Int, text: String) {
		self.uri = uri
		self.languageId = languageId
		self.version = version
		self.text = text
	}

	/// The text document's URI.
	public var uri: DocumentUri

	/// The text document's language identifier.
	public var languageId: String

	/// The version number of this document (it will strictly increase after each change, including
	/// undo/redo).
	public var version: Int

	/// The content of the opened text document.
	public var text: String
}

/// An identifier to denote a specific version of a text document.
public struct VersionedTextDocumentIdentifier /* : TextDocumentIdentifier */ {
	/// The text document's URI.
	public var uri: DocumentUri

	/// The version number of this document.
	public var version: Int

    public init(uri: DocumentUri, version: Int) {
		self.uri = uri
        self.version = version
    }
}

/// A parameter literal used in requests to pass a text document and a position inside that
/// document.
public struct TextDocumentPositionParams {
	public init(textDocument: TextDocumentIdentifier, position: Position) {
		self.textDocument = textDocument
		self.position = position
	}

	/// The text document.
	public var textDocument: TextDocumentIdentifier

	/// The position inside the text document.
	public var position: Position
}

/// A document filter denotes a document through properties like language, schema or pattern.
/// Examples are a filter that applies to TypeScript files on disk or a filter the applies to JSON
/// files with name package.json:
///
/// { language: 'typescript', scheme: 'file' }
/// { language: 'json', pattern: '**/package.json' }
public struct DocumentFilter {
	public init(language: String? = nil, scheme: String? = nil, pattern: String? = nil) {
		self.language = language
		self.scheme = scheme
		self.pattern = pattern
	}

	/// A language id, like `typescript`.
	public var language: String?

	/// A Uri [scheme](#Uri.scheme), like `file` or `untitled`.
	public var scheme: String?

	/// A glob pattern, like `*.{ts,js}`.
	public var pattern: String?
}

public struct DidOpenTextDocumentParams {
	public init(textDocument: TextDocumentItem) {
		self.textDocument = textDocument
	}

	/// The document that was opened.
	public var textDocument: TextDocumentItem
}

public struct DidChangeTextDocumentParams {
	public init(textDocument: VersionedTextDocumentIdentifier, contentChanges: [TextDocumentContentChangeEvent]) {
		self.textDocument = textDocument
		self.contentChanges = contentChanges
	}

	/// The document that did change. The version number points to the version after all provided content changes have been applied.
	public var textDocument: VersionedTextDocumentIdentifier

	/// The actual content changes.
	public var contentChanges: [TextDocumentContentChangeEvent]
}

/// An event describing a change to a text document. If range and rangeLength are omitted the new
/// text is considered to be the full content of the document.
public struct TextDocumentContentChangeEvent {
	public init(text: String, range: Range? = nil, rangeLength: Int? = nil) {
		self.text = text
		self.range = range
		self.rangeLength = rangeLength
	}

	/// The range of the document that changed.
	public var range: Range?

	/// The length of the range that got replaced.
	public var rangeLength: Int?

	/// The new text of the range/document.
	public var text: String
}

/// The parameters send in a will save text document notification.
public struct WillSaveTextDocumentParams {
	public init(textDocument: TextDocumentIdentifier, reason: TextDocumentSaveReason) {
		self.textDocument = textDocument
		self.reason = reason
	}

	/// The document that will be saved.
	public var textDocument: TextDocumentIdentifier

	/// The 'TextDocumentSaveReason'.
	public var reason: TextDocumentSaveReason
}

/// Represents reasons why a text document is saved.
public enum TextDocumentSaveReason: Int {
	/// Manually triggered, e.g. by the user pressing save, by starting debugging, or by an API
	/// call.
	case manual = 1

	/// Automatic after a delay.
	case afterDelay = 2

	/// When the editor lost focus.
	case focusOut = 3
}

public struct DidSaveTextDocumentParams {
	public init(textDocument: TextDocumentIdentifier, text: String? = nil) {
		self.textDocument = textDocument
		self.text = text
	}

	/// The document that was saved.
	public var textDocument: TextDocumentIdentifier

	/// Optional the content when saved. Depends on the includeText value when the save notification
	/// was requested.
	public var text: String?
}

public struct DidCloseTextDocumentParams {
	public init(textDocument: TextDocumentIdentifier) {
		self.textDocument = textDocument
	}

	/// The document that was closed.
	public var textDocument: TextDocumentIdentifier
}

public struct DocumentSymbolParams {
	public init(textDocument: TextDocumentIdentifier) {
		self.textDocument = textDocument
	}

	/// The text document.
	public var textDocument: TextDocumentIdentifier
}

public struct CodeActionParams {
	public init(textDocument: TextDocumentIdentifier, range: Range, context: CodeActionContext) {
		self.textDocument = textDocument
		self.range = range
		self.context = context
	}

	/// The document in which the command was invoked.
	public var textDocument: TextDocumentIdentifier

	/// The range for which the command was invoked.
	public var range: Range

	/// Context carrying additional information.
	public var context: CodeActionContext
}

/// Contains additional diagnostic information about the context in which a code action is run.
public struct CodeActionContext {
	public init(diagnostics: [Diagnostic]) {
		self.diagnostics = diagnostics
	}

	/// An array of diagnostics.
	public var diagnostics: [Diagnostic]
}

public struct CodeLensParams {
	public init(textDocument: TextDocumentIdentifier) {
		self.textDocument = textDocument
	}

	/// The document to request code lens for.
	public var textDocument: TextDocumentIdentifier
}

/// A code lens represents a command that should be shown along with source text, like the number of
/// references, a way to run tests, etc.
///
/// A code lens is _unresolved_ when no command is associated to it. For performance reasons the
/// creation of a code lens and resolving should be done in two stages.
public struct CodeLens {
	public init(range: Range, command: Command? = nil, data: Any? = nil) {
		self.range = range
		self.command = command
		self.data = data
	}

	/// The range in which this code lens is valid. Should only span a single line.
	public var range: Range

	/// The command this code lens represents.
	public var command: Command?

	/// A data entry field that is preserved on a code lens item between
	/// a code lens and a code lens resolve request.
	public var data: Any?
}

public struct DocumentLinkParams {
	public init(textDocument: TextDocumentIdentifier) {
		self.textDocument = textDocument
	}

	/// The document to provide document links for.
	public var textDocument: TextDocumentIdentifier
}

/// A document link is a range in a text document that links to an internal or external resource,
/// like another text document or a web site.
public struct DocumentLink {
	public init(range: Range, target: DocumentUri? = nil) {
		self.range = range
		self.target = target
	}

	/// The range this link applies to.
	public var range: Range
	
	/// The uri this link points to. If missing a resolve request is sent later.
	public var target: DocumentUri?
}

public struct RenameParams {
	public init(textDocument: TextDocumentIdentifier, position: Position, newName: String) {
		self.textDocument = textDocument
		self.position = position
		self.newName = newName
	}
	
	/// The document to format.
	public var textDocument: TextDocumentIdentifier

	/// The position at which this request was sent.
	public var position: Position

	/// The new name of the symbol. If the given name is not valid the request must return a
	/// [ResponseError](#ResponseError) with an appropriate message set.
	public var newName: String
}

/// A document selector is the combination of one or many document filters.
public typealias DocumentSelector = [DocumentFilter];
