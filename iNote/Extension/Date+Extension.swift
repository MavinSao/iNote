//
//  Date+Extension.swift
//  iNote
//
//  Created by Mavin Sao on 27/9/21.
//

import Foundation

extension Date {
    func getFormattedDate(format: String) -> String {
            let dateformat = DateFormatter()
            dateformat.dateFormat = format
            return dateformat.string(from: self)
    }
}
