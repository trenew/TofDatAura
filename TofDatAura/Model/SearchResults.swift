//
//  SearchResults.swift
//  TofDatAura
//
//  Created by User on 02/07/2022.
//

import Foundation

struct SearchResults: Codable {
    var total: Int
    var total_pages: Int
    var results: [Photo]

    init() {
        total = 0
        total_pages = 0
        results = []
    }
}
