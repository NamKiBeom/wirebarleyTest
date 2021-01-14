//
//  extension+Date.swift
//  WirebarleyTest
//
//  Created by 남기범 on 2021/01/14.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return dateFormatter.string(from: self)
    }
}
