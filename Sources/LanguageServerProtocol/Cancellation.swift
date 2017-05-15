/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

/// The base protocol offers support for request cancellation. To cancel a request, a notification
/// message with the following properties is sent:
/// Notification:
///   method: `$/cancelRequest`
///   params: `CancelParams` defined as follows:
public struct CancelParams {
    public init(id: RequestId) {
        self.id = id
    }
    
    /// The ID of the request to cancel.
    public var id: RequestId
}
