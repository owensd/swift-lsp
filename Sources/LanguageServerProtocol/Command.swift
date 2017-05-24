/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

import JSONLib

/// Represents a reference to a command. Provides a title which will be used to represent a command
/// in the UI. Commands are identified using a string identifier and the protocol currently doesn't
/// specify a set of well known commands. So executing a command requires some tool extension code.
public struct Command {
	public init(title: String, command: String, arguments: JSValue? = nil) {
		self.title = title
		self.command = command
		self.arguments = arguments
	}
	
	/// Title of the command, like `save`.
	public var title: String

    /// The identifier of the actual command handler.
	public var command: String

	/// Arguments that the command handler should be invoked with.
	/// SpecViolation: Value should be `Any`.
	public var arguments: JSValue?
}
