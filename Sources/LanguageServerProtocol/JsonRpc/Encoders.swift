/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

import JSONLib

#if os(macOS)
import os.log
#endif

@available(macOS 10.12, *)
fileprivate let log = OSLog(subsystem: "com.kiadstudios.languageserverprotocol", category: "Encodable")

public extension Encodable {
	func toJson() -> JSValue {
		var json: JSValue = [:]
		let mirror = Mirror(reflecting: self)
		for (label, value) in mirror.children {
            if let name = label {
                if let value = value as? Encodable {
    				json[name] = value.toJson()
                }
                else {
                    // To check if the `Encodable` is actually an `Optional<Encodable>` we need to
                    // go through a bit of a gymnastics go around.
                    let valueMirror = Mirror(reflecting: value)
                    if valueMirror.displayStyle == .optional {
                        if let (_, some) = valueMirror.children.first {
                            if let some = some as? Encodable {
                                json[name] = some.toJson()
                            }
                            else {
                                if #available(macOS 10.12, *) {
                                    os_log("Property %{public}@ does not support serialization", log: log, type: .default, name)
                                }
                            }
                        }
                        else {
                            // `Optional.None` values will not be encoded at all.
                        }
                    }
                    else {
                        if #available(macOS 10.12, *) {
                            os_log("Property %{public}@ does not support serialization", log: log, type: .default, name)
                        }
                    }
                }
            }
            else {
                if #available(macOS 10.12, *) {
                    os_log("Property does not have name.", log: log, type: .default)
                }
            }
		}
		return json
	}
}

extension String: Encodable {
    public func toJson() -> JSValue {
        return JSValue(self)
    }
}

extension Double: Encodable {
    public func toJson() -> JSValue {
        return JSValue(self)
    }
}

extension Bool: Encodable {
    public func toJson() -> JSValue {
        return JSValue(self)
    }
}

extension Int: Encodable {
    public func toJson() -> JSValue {
        return JSValue(Double(self))
    }
}

extension Array where Iterator.Element == String {
    public func toJson() -> JSValue {
        let content = self.joined(separator: ",")
        return JSValue("[\(content)]")
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


extension ResponseMessage: Encodable {}
extension ResponseResult: Encodable {
    public func toJson() -> JSValue {
        switch self {
        case let .result(encodable):
            if let encodable = encodable {
                return encodable.toJson()
            }
            return nil
        case let .error(code, message, data):
            var json: JSValue = [:]
            json["code"] = JSValue(Double(code))
            json["message"] = JSValue(message)
            if let data = data {
                json["data"] = data.toJson()
            }
            return json
        }
    }
}

extension RequestId: Encodable {
    public func toJson() -> JSValue {
        switch self {
        case let .number(value): return JSValue(Double(value))
        case let .string(value): return JSValue(value)
        }
    }
}

extension InitializeResult: Encodable {}