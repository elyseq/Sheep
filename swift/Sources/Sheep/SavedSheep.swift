//
//  SavedSheep.swift
//  Sheep
//
//  Created by Elyse Q on 4/23/26.
//

import SwiftGodot

final class SavedSheep : @unchecked Sendable{
    static let shared = SavedSheep()
    var woolLocations: [[String]] = []
    var woolColors: [[Color]] = []
    var hasSavedAppearance: Bool = false

    private init() {}

    func save(from controller: WoolController) {
        woolLocations = controller.woolLocations
        woolColors = []

        for row in controller.woolNodesMatrix {
            var colorRow: [Color] = []

            for wool in row {
                if let wool = wool {
                    colorRow.append(wool.getColor())
                } else {
                    colorRow.append(Color(r: 0, g: 0, b: 0, a: 0))
                }
            }
            woolColors.append(colorRow)
        }
        
        hasSavedAppearance = true
        GD.print("Saved sheep appearance")
    }

}
