//
//  FIOMisc.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 12/5/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Completions

typealias QIOSimpleCompletion = () -> Void
typealias QIOErrorCompletion = (Error?) -> Void
typealias QIOStringCompletion = (String) -> Void
typealias QIOStringErrorCompletion = (String?, Error?) -> Void
typealias QIOBoolCompletion = (Bool) -> Void
typealias QIOTwoBoolCompletion = (Bool, Bool) -> Void
typealias QIOImageCompletion = (UIImage) -> Void
typealias QIOStringOptCompletion = (String?) -> Void
typealias QIOBoolErrorCompletion = (Bool, Error?) -> Void
