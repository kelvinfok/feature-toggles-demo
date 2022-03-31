//
//  String+Extension.swift
//  ios-feature-toggle-demo
//
//  Created by Kelvin Fok on 31/3/22.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
