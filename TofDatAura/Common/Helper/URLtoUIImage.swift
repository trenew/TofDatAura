//
//  URLtoUIImage.swift
//  TofDatAura
//
//  Created by User on 01/07/2022.
//

import Foundation
import SwiftUI

extension String {
    func loadPhotoFromURL() -> UIImage? {
        guard let url = URL(string: self),
              let data: Data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: data)
    }
}
