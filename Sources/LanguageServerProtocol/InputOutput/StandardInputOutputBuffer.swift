/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

#if os(Linux)
    import Glibc
#else
    import Darwin
    import os.log
#endif

import Foundation
import Dispatch

@available(macOS 10.12, *)
fileprivate let log = OSLog(subsystem: "com.kiadstudios.languageserverprotocol", category: "StandardInputOutputBuffer")

/// A message source that pulls data in from `stdin`.
public final class StandardInputOutputBuffer: InputOutputBuffer {
    /// Internal queue used to handle the message input source.
    private var inputQueue = DispatchQueue(
        label: "com.kiadstudios.swiftlangsrv.standardinputbuffer",
        attributes: .concurrent
    )

    /// Whew! Look at the value of this!
    public init() {}

    /// Continuously monitors the `stdin`.
    public func run(received: @escaping (Message) -> Message?) {
        inputQueue.async {
            let messageBuffer = MessageBuffer()
            var input = fd_set()

            while (true) {
                zero(fd: &input)
                set(descriptor: STDIN_FILENO, fd: &input)

                let maxMessageSize = 8192
                var buffer = [UInt8](repeating: 0, count: maxMessageSize)

                let result = select(STDIN_FILENO + 1, &input, nil, nil, nil)
                if (result == -1) {
                    fatalError("*** error in select() ***")
                }
                else if (result > 0) {
                    let bytesRead = read(STDIN_FILENO, &buffer, maxMessageSize)
                    if bytesRead < 0 {
                        if #available(macOS 10.12, *) {
                            os_log("unable to read from buffer: %d", log: log, type: .default, errno)
                        }
                        fatalError("Unable to read from the input buffer.")
                    }
                    else if bytesRead > 0 {
                        let messages = messageBuffer.write(data: [UInt8](buffer[0..<bytesRead]))
                        for message in messages {
                            if let response = received(message) {
                                let header = message.header.description.data(using: .utf8)!
                                let content = Data(bytes: response.content)
                                if #available(macOS 10.12, *) {
                                    os_log("writing header:\n%{public}@", log: log, type: .default, message.header.description)
                                    os_log("writing content:\n%{public}@", log: log, type: .default, String(data: content, encoding: .utf8)!)
                                }
                                FileHandle.standardOutput.write(header)
                                FileHandle.standardOutput.write(content)
                            }
                            else {
                                if #available(macOS 10.12, *) {
                                    os_log("response was nil", log: log, type: .default)
                                }
                            }
                        }
                    }
                }
                else {
                    if #available(macOS 10.12, *) {
                        os_log("unable to select on stdin: %d", log: log, type: .default, errno)
                    }
                    fatalError("no stdin present")
                }
            }
        }
    }

    public func stop() {
        inputQueue.suspend()
    }
}

#if os(macOS)
/// Based on the file descriptor, the appropriate bit will be set in the `fd_set`.
private func set(descriptor: Int32, fd: inout fd_set) {
    let offset: Int32 = descriptor / 16
    let mask: Int32 = 1 << (descriptor % 16)

    switch offset {
    case 0: fd.fds_bits.0 |= mask
    case 1: fd.fds_bits.1 |= mask
    case 2: fd.fds_bits.2 |= mask
    case 3: fd.fds_bits.3 |= mask
    case 4: fd.fds_bits.4 |= mask
    case 5: fd.fds_bits.5 |= mask
    case 6: fd.fds_bits.6 |= mask
    case 7: fd.fds_bits.7 |= mask
    case 8: fd.fds_bits.8 |= mask
    case 9: fd.fds_bits.9 |= mask
    case 10: fd.fds_bits.10 |= mask
    case 11: fd.fds_bits.11 |= mask
    case 12: fd.fds_bits.12 |= mask
    case 13: fd.fds_bits.13 |= mask
    case 14: fd.fds_bits.14 |= mask
    case 15: fd.fds_bits.15 |= mask
    default: fatalError("Invalid descriptor offset: \(offset)")
    }
}

/// Resets all of the bits to `0` in the `fd_set`.
@inline(__always) private func zero(fd: inout fd_set) {
    fd.fds_bits = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
}
#endif


#if os(Linux)
/// Based on the file descriptor, the appropriate bit will be set in the `fd_set`.
private func set(descriptor: Int32, fd: inout fd_set) {
    let offset: Int32 = descriptor / 16
    let mask: Int = 1 << Int(descriptor % 16)

    switch offset {
    case 0: fd.__fds_bits.0 |= mask
    case 1: fd.__fds_bits.1 |= mask
    case 2: fd.__fds_bits.2 |= mask
    case 3: fd.__fds_bits.3 |= mask
    case 4: fd.__fds_bits.4 |= mask
    case 5: fd.__fds_bits.5 |= mask
    case 6: fd.__fds_bits.6 |= mask
    case 7: fd.__fds_bits.7 |= mask
    case 8: fd.__fds_bits.8 |= mask
    case 9: fd.__fds_bits.9 |= mask
    case 10: fd.__fds_bits.10 |= mask
    case 11: fd.__fds_bits.11 |= mask
    case 12: fd.__fds_bits.12 |= mask
    case 13: fd.__fds_bits.13 |= mask
    case 14: fd.__fds_bits.14 |= mask
    case 15: fd.__fds_bits.15 |= mask
    default: fatalError("Invalid descriptor offset: \(offset)")
    }
}

/// Resets all of the bits to `0` in the `fd_set`.
@inline(__always) private func zero(fd: inout fd_set) {
    fd.__fds_bits = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
}
#endif
