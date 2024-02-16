//
//  Theme.swift
//  AAC
//
//  Created by Steven Huang on 2/12/24.
//

import SwiftUI

struct Theme: Hashable, Identifiable {
    var id = UUID()
    var name: String
    var foregroundColor: Color
    var backgroundColor: Color
}

let themes: [Theme] = [
    Theme(name: "Default", foregroundColor: .black, backgroundColor: .white),
    Theme(name: "Black/Yellow", foregroundColor: .black, backgroundColor: .yellow),
    Theme(name: "Black/Red", foregroundColor: .black, backgroundColor: .red),
    Theme(name: "White/Blue", foregroundColor: .white, backgroundColor: .blue),
    Theme(name: "White/Green", foregroundColor: .white, backgroundColor: .green),
    Theme(name: "Blue/Yellow", foregroundColor: .blue, backgroundColor: .yellow)
]
