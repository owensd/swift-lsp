/*
 * Copyright (c) Kiad Studios, LLC. All rights reserved.
 * Licensed under the MIT License. See License in the project root for license information.
 */

import JSONLib
import LanguageServerProtocol



// NOTE(owensd): These two protocols should maybe move to the JSONLib library itself.

extension JSValue {
    var integer: Int? { 
        if let number = self.number {
            return Int(number)
        }
        return nil
     }
}





