//
//  Extentions.swift
//  Coffee Shop Admin
//
//  Created by constantine kos on 09.10.2020.
//

import Foundation


extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
