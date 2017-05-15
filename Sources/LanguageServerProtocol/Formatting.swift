/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

public struct DocumentFormattingParams {
    public init(textDocument: TextDocumentIdentifier, options: FormattingOptions) {
        self.textDocument = textDocument
        self.options = options
    }

	/// The document to format.
	public var textDocument: TextDocumentIdentifier

	/// The format options.
	public var options: FormattingOptions
}

/// Value-object describing what options formatting should use.
public struct FormattingOptions {
    public init(tabSize: Int = 4, insertSpaces: Bool = true) {
        self.tabSize = tabSize
        self.insertSpaces = insertSpaces
    }

	/// Size of a tab in spaces.
	public var tabSize: Int

	/// Prefer spaces over tabs.
	public var insertSpaces: Bool

    // Signature for further properties.
	//[key: string]: boolean | number | string;
}

public struct DocumentRangeFormattingParams {
    public init(textDocument: TextDocumentIdentifier, range: Range, options: FormattingOptions) {
        self.textDocument = textDocument
        self.range = range
        self.options = options
    }

	/// The document to format.
	public var textDocument: TextDocumentIdentifier

	/// The range to format
	public var range: Range

	/// The format options
	public var options: FormattingOptions
}

public struct DocumentOnTypeFormattingParams {
    public init(textDocument: TextDocumentIdentifier, position: Position, ch: String, options: FormattingOptions) {
        self.textDocument = textDocument
        self.position = position
        self.ch = ch
        self.options = options
    }

	/// The document to format.
	public var textDocument: TextDocumentIdentifier

	/// The position at which this request was sent.
	public var position: Position

	/// The character that has been typed.
	public var ch: String

	/// The format options.
	public var options: FormattingOptions
}