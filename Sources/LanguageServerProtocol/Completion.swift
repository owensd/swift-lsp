/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

import JSONLib

/// Represents a collection of [completion items](#CompletionItem) to be presented
/// in the editor.
public struct CompletionList {
    public init(isIncomplete: Bool, items: [CompletionItem]) {
        self.isIncomplete = isIncomplete
        self.items = items
    }

    /// This list it not complete. Further typing should result in recomputing
    /// this list.
    public var isIncomplete: Bool

    /// The completion items.
    public var items: [CompletionItem]
}

/// Defines whether the insert text in a completion item should be interpreted as
/// plain text or a snippet.
public enum InsertTextFormat: Int {
    /// The primary text to be inserted is treated as a plain string.
    case PlainText = 1

    /// The primary text to be inserted is treated as a snippet.
    ///
    /// A snippet can define tab stops and placeholders with `$1`, `$2` and `${3:foo}`. `$0` defines
    /// the final tab stop, it defaults to the end of the snippet. Placeholders with equal
    /// identifiers are linked, that is typing in one will update others too.
    ///
    /// See also:
    /// https://github.com/Microsoft/vscode/blob/master/src/vs/editor/contrib/snippet/common/snippet.md
    case Snippet = 2
}

public struct CompletionItem {
    public init(
            label: String,
            kind: CompletionItemKind? = nil,
            detail: String? = nil, 
            documentation: String? = nil, 
            sortText: String? = nil, 
            filterText: String? = nil, 
            insertText: String? = nil, 
            insertTextFormat: InsertTextFormat? = nil, 
            textEdit: TextEdit? = nil, 
            additionalTextEdits: [TextEdit]? = nil, 
            command: Command? = nil,
            data: JSValue? = nil) {
        self.label = label
        self.kind = kind
        self.detail = detail
        self.documentation = documentation
        self.sortText = sortText
        self.filterText = filterText
        self.insertText = insertText
        self.insertTextFormat = insertTextFormat
        self.textEdit = textEdit
        self.additionalTextEdits = additionalTextEdits
        self.command = command
        self.data = data
    }

    /// The label of this completion item. By default also the text that is inserted when selecting
    /// this completion.
    public var label: String

    /// The kind of this completion item. Based of the kind an icon is chosen by the editor.
    public var kind: CompletionItemKind?

    /// A human-readable string with additional information
    /// about this item, like type or symbol information.
    public var detail: String?

    /// A human-readable string that represents a doc-comment.
    public var documentation: String?

    /// A string that should be used when comparing this item with other items. When `falsy` the
    /// label is used.
    public var sortText: String?

    /// A string that should be used when filtering a set of completion items. When `falsy` the
    /// label is used.
    public var filterText: String?

    /// A string that should be inserted a document when selecting this completion. When `falsy` the
    /// label is used.
    public var insertText: String?

    /// The format of the insert text. The format applies to both the `insertText` property and the
    /// `newText` property of a provided `textEdit`.
    public var insertTextFormat: InsertTextFormat?

    /// An edit which is applied to a document when selecting this completion. When an edit is
    /// provided the value of `insertText` is ignored.
    ///
    /// Note: The range of the edit must be a single line range and it must contain the position at
    /// which completion has been requested.
    public var textEdit: TextEdit?

    /// An optional array of additional text edits that are applied when selecting this completion.
    /// Edits must not overlap with the main edit nor with themselves.
    public var additionalTextEdits: [TextEdit]?

    /// An optional command that is executed *after* inserting this completion.
    ///
    /// Note: that additional modifications to the current document should be described with the
    /// additionalTextEdits-property.
    public var command: Command?

    /// An data entry field that is preserved on a completion item between a completion and a
    /// completion resolve request.
    /// SpecViolation: Value should be `Any`.
    public var data: JSValue?
}

/// The kind of a completion entry.
public enum CompletionItemKind: Int {
    case text = 1
    case method = 2
    case function = 3
    case constructor = 4
    case field = 5
    case variable = 6
    case `class` = 7
    case interface = 8
    case module = 9
    case property = 10
    case unit = 11
    case value = 12
    case `enum` = 13
    case keyword = 14
    case snippet = 15
    case color = 16
    case file = 17
    case reference = 18
}

public struct ReferenceParams {
    public init(textDocument: TextDocumentIdentifier, position: Position, context: ReferenceContext) {
        self.textDocument = textDocument
        self.position = position
        self.context = context
    }

    /// The text document.
    public var textDocument: TextDocumentIdentifier

    /// The position inside the text document.
    public var position: Position

    public var context: ReferenceContext
}

public struct ReferenceContext {
    public init(includeDeclaration: Bool) {
        self.includeDeclaration = includeDeclaration
    }

    /// Include the declaration of the current symbol.
    public var includeDeclaration: Bool
}

public enum CompletionListResult {
    case completionItems([CompletionItem])
    case completionList(CompletionList)
}

/// Represents information about programming constructs like variables, classes, interfaces etc.
public struct SymbolInformation {

    public init(name: String, kind: SymbolKind, location: Location, containerName: String? = nil) {
        self.name = name
        self.kind = kind
        self.location = location
        self.containerName = containerName
    }

    /// The name of this symbol.
    public var name: String

    /// The kind of this symbol.
    public var kind: SymbolKind

    /// The location of this symbol.
    public var location: Location

    /// The name of the symbol containing this symbol.
    public var containerName: String?
}

/// A symbol kind.
public enum SymbolKind: Int {
    case file = 1
    case module = 2
    case namespace = 3
    case package = 4
    case `class` = 5
    case method = 6
    case property = 7
    case field = 8
    case constructor = 9
    case `enum` = 10
    case interface = 11
    case function = 12
    case variable = 13
    case constant = 14
    case string = 15
    case number = 16
    case boolean = 17
    case array = 18
}

public struct Hover {

    public init(contents: [MarkedString], range: Range? = nil) {
        self.contents = contents
        self.range = range
    }

    public var contents: [MarkedString]

    /// An optional range is a range inside a text document that is used to visualize a hover, e.g.
    /// by changing the background color.
    public var range: Range?
}

/// MarkedString can be used to render human readable text. It is either a markdown string or a
/// code-block that provides a language and a code snippet. The language identifier is semantically
/// equal to the optional language identifier in fenced code blocks in GitHub issues. See
/// https://help.github.com/articles/creating-and-highlighting-code-blocks/#syntax-highlighting
///
/// The pair of a language and a value is an equivalent to markdown:
/// ```${language}
/// ${value}
/// ```
///
/// Note that markdown strings will be sanitized - that means html will be escaped.
public enum MarkedString {
    case string(String)
    case code(language: String, value: String)
}

/// Signature help represents the signature of something callable. There can be multiple signature
/// but only one active and only one active parameter.
public struct SignatureHelp {

    public init(
            signatures: [SignatureInformation],
            activeSignature: Int? = nil,
            activeParameter: Int? = nil) {
        self.signatures = signatures
        self.activeSignature = activeSignature
        self.activeParameter = activeParameter
    }

    /// One or more signatures.
    public var signatures: [SignatureInformation]

    /// The active signature. If omitted or the value lies outside the range of `signatures` the
    /// value defaults to zero or is ignored if `signatures.length === 0`. Whenever possible
    /// implementors should make an active decision about the active signature and shouldn't rely on
    /// a default value. In future version of the protocol this property might become mandatory to
    /// better express this.
    public var activeSignature: Int?

    /// The active parameter of the active signature. If omitted or the value lies outside the range
    /// of `signatures[activeSignature].parameters` defaults to 0 if the active signature has
    /// parameters. If the active signature has no parameters it is ignored. In future version of
    /// the protocol this property might become mandatory to better express the active parameter if
    /// the active signature does have any.
    public var activeParameter: Int?
}

/// Represents the signature of something callable. A signature can have a label, like a
/// function-name, a doc-comment, and a set of parameters.
public struct SignatureInformation {

    public init(label: String, documentation: String? = nil, parameters: [ParameterInformation]? = nil) {
        self.label = label
        self.documentation = documentation
        self.parameters = parameters
    }

    /// The label of this signature. Will be shown in the UI.
    public var label: String

    /// The human-readable doc-comment of this signature. Will be shown in the UI but can be
    /// omitted.
    public var documentation: String?

    /// The parameters of this signature.
    public var parameters: [ParameterInformation]?
}

/// Represents a parameter of a callable-signature. A parameter can have a label and a doc-comment.
public struct ParameterInformation {

    public init(label: String, documentation: String? = nil) {
        self.label = label
        self.documentation = documentation
    }

    /// The label of this parameter. Will be shown in the UI.
    public var label: String

    /// The human-readable doc-comment of this parameter. Will be shown in the UI but can be
    /// omitted.
    public var documentation: String?
}

/// A document highlight is a range inside a text document which deserves
/// special attention. Usually a document highlight is visualized by changing
/// the background color of its range.
public struct DocumentHighlight {

    public init(range: Range, kind: DocumentHighlightKind? = nil) {
        self.range = range
        self.kind = kind
    }
    
	/// The range this highlight applies to.
	public var range: Range

	/// The highlight kind, default is DocumentHighlightKind.Text.
	public var kind: DocumentHighlightKind?
}

/// A document highlight kind.
public enum DocumentHighlightKind: Int {
	/// A textual occurrence.
	case text = 1

	/// Read-access of a symbol, like reading a variable.
	case read = 2

	/// Write-access of a symbol, like writing to a variable.
	case write = 3
}