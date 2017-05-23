/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

public struct DidChangeConfigurationParams {
    public init(settings: Any) {
        self.settings = settings
    }
    
	/// The actual changed settings
	public var settings: Any
}

public struct DidChangeWatchedFilesParams {
    public init(changes: [FileEvent]) {
        self.changes = changes
    }

	/// The actual file events.
	public var changes: [FileEvent]
}

/// An event describing a file change.
public struct FileEvent {
    public init(uri: DocumentUri, type: FileChangeType) {
        self.uri = uri
        self.type = type
    }

	/// The file's URI.
	public var uri: DocumentUri

	/// The change type.
	public var type: FileChangeType
}

/// The file event type.
public enum FileChangeType: Int {
	case created = 1
	case changed = 2
	case deleted = 3
}

/// The parameters of a Workspace Symbol Request.
public struct WorkspaceSymbolParams {
    public init(query: String) {
        self.query = query
    }

	/// A non-empty query string
	public var query: String
}

public struct ExecuteCommandParams {
    public init(command: String, arguments: [String]? = nil) {
        self.command = command
        self.arguments = arguments
    }

	/// The identifier of the actual command handler.
	public var command: String

	/// Arguments that the command should be invoked with.
	public var arguments: [String]?
}

public struct ApplyWorkspaceEditParams {
    public init(edit: WorkspaceEdit) { 
        self.edit = edit
    }
    
	/// The edits to apply.
	public var edit: WorkspaceEdit
}