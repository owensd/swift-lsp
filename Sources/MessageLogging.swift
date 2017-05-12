/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */


/// The various classifications for the messages shown to the user.
public enum MessageType: Int {
	case error = 1
	case warning = 2
	case info = 3
	case log = 4
}

/// The show message notification is sent from a server to a client to ask the client to display a
/// particular message in the user interface.
public struct ShowMessageParams {
    public init(type: MessageType, message: String) {
        self.type = type
        self.message = message
    }

    /// The type of message.
    public var type: MessageType

    /// The message to be shown to the user.
    public var message: String
}

/// The show message request is sent from a server to a client to ask the client to display a
/// particular message in the user interface. In addition to the show message notification the
/// request allows to pass actions and to wait for an answer from the client.
public struct ShowMessageRequestParams {
    public init(type: MessageType, message: String, actions: [MessageActionItem]? = nil) {
        self.type = type
        self.message = message
        self.actions = actions
    }

    /// The type of message.
	public var type: MessageType

    /// The message to be shown to the user.
	public var message: String

	/// The message action items to present.
	public var actions: [MessageActionItem]?
}

public struct MessageActionItem {
	/// A short title like 'Retry', 'Open Log' etc.
	public var title: String
}

/// The log message notification is sent from the server to the client to ask the client to log a
/// particular message.
public struct LogMessageParams {
    public init(type: MessageType, message: String) {
        self.type = type
        self.message = message
    }

	/// The type of message.
    public var type: MessageType

	/// The content of the message to log.
	public var message: String
}