/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

import JSONLib
import LanguageServerProtocol

#if os(macOS)
import os.log
#endif

@available(macOS 10.12, *)
fileprivate let log = OSLog(subsystem: "com.kiadstudios.jsonrpcprotocol", category: "Encodable")

public extension Encodable {
    func encode() -> JSValue {
        func cast<T>(_ x: Any, to: T.Type) -> T? {
            return x as? T
        }

        var json: JSValue = [:]
        let mirror = Mirror(reflecting: self)
        for (label, value) in mirror.children {
            if let name = label {
                if let value = cast(value, to: Optional<Encodable>.self) {
                    if let value = value {
                        json[name] = value.encode()
                    }
                }
                else if let value = cast(value, to: Array<Encodable>.self) {
                    json[name] = value.encode()
                }
                else {
                    if #available(macOS 10.12, *) {
                        os_log("Property '%{public}@' is not an encodable type.", log: log, type: .default, name)
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
    public func encode() -> JSValue {
        return JSValue(self)
    }
}

extension Double: Encodable {
    public func encode() -> JSValue {
        return JSValue(self)
    }
}

extension Bool: Encodable {
    public func encode() -> JSValue {
        return JSValue(self)
    }
}

extension Int: Encodable {
    public func encode() -> JSValue {
        return JSValue(Double(self))
    }
}

extension Array where Iterator.Element == Encodable {
    public func encode() -> JSValue {
        let contents: [JSValue] = self.map { $0.encode() }
        return JSValue(contents)
    }
}




extension ServerCapabilities: Encodable {}
extension TextDocumentSyncOptions: Encodable {}
extension TextDocumentSyncKind: Encodable {}
extension CompletionOptions: Encodable {}
extension CodeLensOptions: Encodable {}
extension SignatureHelpOptions: Encodable {}
extension DocumentOnTypeFormattingOptions: Encodable {}
extension DocumentLinkOptions: Encodable {}
extension ExecuteCommandOptions: Encodable {}
extension ResponseMessage: Encodable {}
extension InitializeResult: Encodable {}

extension ResponseResult: Encodable {
    public func encode() -> JSValue {
        switch self {
        case let .result(encodable):
            if let encodable = encodable {
                return encodable.encode()
            }
            return nil
        case let .error(code, message, data):
            var json: JSValue = [:]
            json["code"] = JSValue(Double(code))
            json["message"] = JSValue(message)
            if let data = data {
                json["data"] = data.encode()
            }
            return json
        }
    }
}

extension RequestId: Encodable {
    public func encode() -> JSValue {
        switch self {
        case let .number(value): return JSValue(Double(value))
        case let .string(value): return JSValue(value)
        }
    }
}
