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

        let json: JSValue = [:]
        // let mirror = Mirror(reflecting: self)
        // for (label, value) in mirror.children {
        //     if let name = label {
        //         if let value = cast(value, to: Optional<EncodableType>.self) {
        //             if let value = value {
        //                 json[name] = value.encode()
        //             }
        //         }
        //         else if let value = cast(value, to: Array<EncodableType>.self) {
        //             json[name] = value.encode()
        //         }
        //         else {
        //             if #available(macOS 10.12, *) {
        //                 os_log("Property '%{public}@' is not an encodable type.", log: log, type: .default, name)
        //             }
        //         }
        //     }
        //     else {
        //         if #available(macOS 10.12, *) {
        //             os_log("Property does not have name.", log: log, type: .default)
        //         }
        //     }
        // }

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
extension InitializeResult: Encodable {}
extension ShowMessageRequestParams: Encodable {}
extension SymbolInformation: Encodable {}
extension Hover: Encodable {}
extension CodeLens: Encodable {}
extension DocumentLink: Encodable {}
extension TextEdit: Encodable {}
extension CompletionListResult: Encodable {}
extension SignatureHelp: Encodable {}
extension Location: Encodable {}
extension DocumentHighlight: Encodable {}
extension Command: Encodable {}
extension WorkspaceEdit: Encodable {}

extension RequestId: Encodable {
    public func encode() -> JSValue {
        switch self {
        case let .number(value): return JSValue(Double(value))
        case let .string(value): return JSValue(value)
        }
    }
}

extension LanguageServerResponse: Encodable {
    private func encode<EncodingType>(_ requestId: RequestId, _ encodables: [EncodingType]?) -> JSValue where EncodingType: Encodable {
        return [
            "jsonrpc": "2.0",
            "id": requestId.encode(),
            "result": /* FIX THIS!! encodables?.encode() ?? */ nil]
    }

    private func encode<EncodingType>(_ requestId: RequestId, _ encodable: EncodingType?) -> JSValue where EncodingType: Encodable {
        return [
            "jsonrpc": "2.0",
            "id": requestId.encode(),
            "result": encodable?.encode() ?? nil]
    }

    private func encode(_ requestId: RequestId) -> JSValue {
        return [
            "jsonrpc": "2.0",
            "id": requestId.encode(),
            "result": nil]
    }

    public func encode() -> JSValue {
        switch self {
        case let .initialize(requestId, result): return encode(requestId, result)
        case let .shutdown(requestId): return encode(requestId)

        case let .showMessageRequest(requestId, result): return encode(requestId, result)

        case let .clientRegisterCapability(requestId): return encode(requestId)
        case let .clientUnregisterCapability(requestId): return encode(requestId)
        
        case let .workspaceSymbol(requestId, result): return encode(requestId, result)
        case let .workspaceExecuteCommand(requestId): return encode(requestId)

        case let .completionItemResolve(requestId, result): return encode(requestId, result)
        case let .codeLensResolve(requestId, result): return encode(requestId, result)
        case let .documentLinkResolve(requestId, result): return encode(requestId, result)
        
        case let .textDocumentWillSaveWaitUntil(requestId, result): return encode(requestId, result)
        case let .textDocumentCompletion(requestId, result): return encode(requestId, result)
        case let .textDocumentHover(requestId, result): return encode(requestId, result)
        case let .textDocumentSignatureHelp(requestId, result): return encode(requestId, result)
        case let .textDocumentReferences(requestId, result): return encode(requestId, result)
        case let .textDocumentDocumentHighlight(requestId, result): return encode(requestId, result)
        case let .textDocumentDocumentSymbol(requestId, result): return encode(requestId, result)
        case let .textDocumentFormatting(requestId, result): return encode(requestId, result)
        case let .textDocumentRangeFormatting(requestId, result): return encode(requestId, result)
        case let .textDocumentOnTypeFormatting(requestId, result): return encode(requestId, result)
        case let .textDocumentDefinition(requestId, result): return encode(requestId, result)
        case let .textDocumentCodeAction(requestId, result): return encode(requestId, result)
        case let .textDocumentCodeLens(requestId, result): return encode(requestId, result)
        case let .textDocumentDocumentLink(requestId, result): return encode(requestId, result)
        case let .textDocumentRename(requestId, result): return encode(requestId, result)
        }
    }
}