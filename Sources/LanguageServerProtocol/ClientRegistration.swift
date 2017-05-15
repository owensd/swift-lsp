/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

/// General parameters to to register for a capability.
public struct Registration {
    public init(id: String, method: String, registerOptions: Any? = nil) {
        self.id = id
        self.method = method
        self.registerOptions = registerOptions
    }

	/// The id used to register the request. The id can be used to deregister the request again.
	public var id: String

	/// The method / capability to register for.
	public var method: String

	/// Options necessary for the registration.
	public var registerOptions: Any?
}

public struct RegistrationParams {
    public init(registrations: [Registration]) {
        self.registrations = registrations
    }

	public var registrations: [Registration];
}

/// General parameters to unregister a capability.
public struct Unregistration {
    public init(id: String, method: String) {
        self.id = id
        self.method = method
    }

	/// The id used to unregister the request or notification. Usually an id provided during the
	/// register request.
	public var id: String

	/// The method / capability to unregister for.
	public var method: String
}

public struct UnregistrationParams {
    public init(unregisterations: [Unregistration]) {
        self.unregisterations = unregisterations
    }

	public var unregisterations: [Unregistration];
}
