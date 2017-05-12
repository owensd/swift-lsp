/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

extension String: Error {}

#if os(Linux)
// These are simply no-op stubs for now.

struct OSLog {
    init(subsystem: String, category: String) {}
}

enum LogTool {
    case `default`
}

func os_log(_ string: String, log: OSLog, type: LogTool, _ args: Any...) {}

#endif

extension Array {
    public func at(_ index: Int) -> Element? {
        return (index < self.count) ? self[index] : nil
    }
}