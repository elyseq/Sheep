//
//  SavedSheep.swift
//  Sheep
//
//  Created by Elyse Q on 4/23/26.
//

import SwiftGodot

struct SheepAppearance {
    var woolLocations: [[String]]
    var woolColors: [[Color]]
}

final class SavedSheep : @unchecked Sendable{
    static let shared = SavedSheep()
    var selectedSheepNum: Int = 0
    var appearancesBySheepNum: [Int: SheepAppearance] = [:]

    private init() {}
    
    func save(from controller: WoolController) {
        var colors: [[Color]] = []

        for rowIndex in 0..<controller.woolLocations.count {
            var colorRow: [Color] = []

            for colIndex in 0..<controller.woolLocations[rowIndex].count {
                let locationValue = controller.woolLocations[rowIndex][colIndex]

                if locationValue == "1" || locationValue == "2",
                   rowIndex < controller.woolNodesMatrix.count,
                   colIndex < controller.woolNodesMatrix[rowIndex].count,
                   let wool = controller.woolNodesMatrix[rowIndex][colIndex] {
                    colorRow.append(wool.getColor())
                } else {
                    colorRow.append(Color(r: 0, g: 0, b: 0, a: 0))
                }
            }

            colors.append(colorRow)
            GD.print("Saved sheep Num: \(selectedSheepNum)")
            GD.print("Saved sheep rows: \(controller.woolLocations.count)")
        }

        appearancesBySheepNum[selectedSheepNum] = SheepAppearance(
            woolLocations: controller.woolLocations,
            woolColors: colors
        )

        GD.print("Saved sheep \(selectedSheepNum)")
    }
    
    func appearanceForSelectedSheep() -> SheepAppearance? {
        return appearancesBySheepNum[selectedSheepNum]
    }

    func appearance(for sheepNum: Int) -> SheepAppearance? {
        return appearancesBySheepNum[sheepNum]
    }
    
    func readFile(fileName: String) -> [[String]] {
        let path = "res://assets/\(fileName)"
        guard let file = FileAccess.open(path: path, flags: .read) else {
            print("Could not open file at \(path)")
            return []
        }
        
        let content = file.getAsText()
        return content.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map { $0.components(separatedBy: ",") }
    }

}
