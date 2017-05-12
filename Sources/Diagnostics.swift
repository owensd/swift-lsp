/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

import JSONLib

/// Represents a diagnostic, such as a compiler error or warning. Diagnostic objects are only
/// valid in the scope of a resource.
public struct Diagnostic {
	/// The range at which the message applies.
	public var range: Range

	/// The diagnostics' severity. Can be omitted. If omitted it is up to the client to interpret
	/// diagnostics as error, warning, info or hint.
	public var severity: DiagnosticSeverity?

	/// The diagnostics code. Can be omitted.
	var code: DiagnosticCode?

	/// A human-readable string describing the source of this diagnostic, e.g. 'typescript' or
    /// 'super lint'.
	var source: String?

	/// The diagnostics message.
	var message: String
}

/// A code to use within the `Diagnostic` type.
public enum DiagnosticCode {
    case number(Int)
    case string(String)
}

/// The protocol currently supports the following diagnostic severities:
public enum DiagnosticSeverity: Int {
	/// Reports an error.
	case error = 1
	/// Reports a warning.
	case warning = 2
	/// Reports an information.
	case information = 3
	/// Reports a hint.
	case hint = 4
}

public enum TraceSetting {
    case off
    case messages
    case verbose
}

// MARK: Serialization

extension TraceSetting: Decodable {
	public static func from(json: JSValue) throws -> TraceSetting {
		if !json.hasValue { return .off }
		guard let value = json.string else {
			throw "The trace setting must be a string or not present."
		}
		switch value {
		case "off": return .off
		case "messages": return .messages
		case "verbose": return .verbose
		default: throw "'\(value)' is an unsupported value"
		}
	}
}