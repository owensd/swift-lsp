/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

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
			data: Any? = nil) {
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
	public var data: Any?
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