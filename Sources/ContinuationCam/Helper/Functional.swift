//
//  Functional.swift
//
//
//  Created by Julius Brummack on 24.02.24.
//

import Foundation

///Transforms a Type into another Type
typealias Transformer<T, TR> = ((T) -> (TR))
///Does something with a Type
typealias VoidT<T> = Transformer<T, ()>
