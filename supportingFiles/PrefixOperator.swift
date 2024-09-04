//
//  PrefixOperator.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 23/08/24.
//

import Foundation

prefix operator /

prefix func /(string: String?) -> String {
    return string ?? ""
}
