# Language Server Protocol

![travis-ci badge status](https://travis-ci.org/owensd/LanguageServerProtocol.svg?branch=master)

Welcome to the Swift implementation of the [Language Server Protocol][1]. This provides a complete
implementation of v3.0 of the spec. The intention is to allow for the building of language servers
with the Swift language.

There are two other projects that serve as an illustration on how to integrate with
[Visual Studio Code][2]:
  - [vscode-swift][3] - The VS Code hosting integration. This packages [swift-langsrv] and includes
                        other Swift language enhancements, such as syntax highlighting and snippets.
  - [swift-langsrv][4] - The Swift Language Server based on this library.

## Design Breakdown

The system is broken up into parts that are designed to be interchangeable. Each layer of the
system is agnostic of the other layers, except for the data contracts that between each layer.
The entirety of the contract is defined in `LanguageServerProtocol.swift`.

The basic flow through the system looks like this:

An `InputBuffer` receives data from a some source, say `stdin`. It takes that data and converts
it into a `Message` based on the spec. That message is then translated by an implementation of
a `MessageProtocol` type, say `JsonRpcProtocol`. At this point, the raw message has been
converted into a transport-agnostic `LanguageServerCommand` that can be used by any implementation
of your own language server type.

The design of this system to both conform to the [Language Server Protocol][1] spec while also
providing some leeway on how each of the layers interact. For instance, with this design, it is
completely possible to change the input source to be IPC and the message format to be a binary
representation. 

> Copyright (c) Kiad Studios, LLC. All rights reserved.
> Licensed under the MIT License. See License in the project root for license information.

[1]: https://github.com/Microsoft/language-server-protocol
[2]: https://code.visualstudio.com
[3]: https://github.com/owensd/vscode-swift
[4]: https://github.com/owensd/swift-langsrv