//
//  Calendar+Extension.swift
//  TofDatAura
//
//  Created by User on 30/06/2022.
//

import Foundation

extension Calendar {
    public static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy - HH:mm"
        return formatter.string(from: date)
    }
    
    public static func formattedDate(_ dateString: String) -> String {
        let formattedtString =  ISO8601DateFormatter().date(from: dateString).map { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, yyyy - HH:mm"
            
            return formatter.string(from: date)
        } ?? ""
        return formattedtString
    }
}
