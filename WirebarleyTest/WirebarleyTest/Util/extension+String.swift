//
//  extension+String.swift
//  WirebarleyTest
//
//  Created by 남기범 on 2021/01/14.
//

import Foundation

extension String{
    func getArrayAfterRegex(regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func toDecimal() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        guard let result = numberFormatter.string(from: NSNumber(value: Double(self) ?? 0)) else {
            fatalError("Double value doesn't convert String")
        }
        
        return result
    }
}
