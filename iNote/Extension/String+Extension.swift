//
//  String+Extension.swift
//  iNote
//
//  Created by Mavin Sao on 27/9/21.
//

import Foundation

extension String{
    var firstLine: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).first ?? "" // returns the first line of the
    }
    var afterFirstLine: String{
        var lines = self.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
        lines.removeFirst()
        return  lines.joined() // return second line
    }
}
