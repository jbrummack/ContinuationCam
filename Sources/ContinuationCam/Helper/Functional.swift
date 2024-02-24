//
//  Functional.swift
//
//
//  Created by Julius Brummack on 24.02.24.
//

import Foundation

///Macro for (T) -> (U)
typealias Transformer<T, TR> = ((T) -> (TR))
///Macro for (T) -> ()
typealias VoidT<T> = Transformer<T, ()>
