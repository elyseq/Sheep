//
//  WoolController.swift
//  Sheep
//
//  Created by Nora Betry on 3/11/26.
//
//
//  PlayerController.swift
//  Sheep
//
//  Created by Elyse Q on 3/10/26.
//

import SwiftGodot
import Foundation

@Godot
class WoolController: CharacterBody2D {
    var woolLocations: [[String]] = []
    var woolNodesMatrix : [[WoolThing?]] = []
    override func _ready() {
        GD.print("hrllo")
        let sheepsprite = Sprite2D()
        sheepsprite.texture = GD.load(path: "res://assets/TransparentSheep.png") as? Texture2D
        sheepsprite.position = Vector2(x: 500, y: 500)
        sheepsprite.scale = Vector2(x: 1.5, y: 1.5)
        addChild(node:sheepsprite)
        
        let woolLocations = readFile(fileName: "sheepmatrix.txt")
        for y in 0...woolLocations.count-1{
            let ypos = 10 * y - 130
            woolNodesMatrix.append([])
            for x in 0...woolLocations[y].count-1{
                let xpos = 10 * x - 90
                if(woolLocations[y][x] == "1" || woolLocations[y][x] == "2"){
                    let wool = makeWoolNode(Vector2(x: Float(xpos), y: Float(ypos)))
                    woolNodesMatrix[y].append(wool as! WoolThing)
                    sheepsprite.addChild(node: wool)

                }
                else {
                                woolNodesMatrix[y].append(nil)
                            }
            }
        
        }
        GD.print(woolNodesMatrix)
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
    func checkForFloating(x: Int,y: Int){
        let rows = woolLocations.count
        let cols = woolLocations[0].count
        var safeMatrix: [[Bool]] = Array(repeating: Array(repeating: false, count: cols), count: rows)
        
        for r in 0..<rows{
            for c in 0..<cols{
                var is_touching_one = false
                for delta in [(0,1), (0,-1), (1,0), (-1,0)]{
                    let newRow = r + delta.0
                    let newCol = r + delta.1
                    if(0 <= newRow && newRow < rows && 0 <= newCol && newCol < cols && woolLocations[newRow][newCol] == "1"){
                        is_touching_one = true
                        break
                    }
                    
                    if(is_touching_one){
                        recursiveCheck(r: r, c: c, rows: rows, cols: cols, safeMatrix: safeMatrix)
                    }
                }
            }
        }
        
        for r in 0...rows{
            for c in 0...cols{
                if(woolLocations[r][c] == "2" && !safeMatrix[r][c]){
                    woolLocations[r][c] = "0"
                }
            }
            
        }
    }
        
    
    
    func recursiveCheck(r: Int, c: Int, rows: Int, cols: Int, safeMatrix: [[Bool]]){
        if (r < 0 || r >= rows || c < 0 || c >= cols || safeMatrix[r][c] || woolLocations[r][c] != "2"){
            return
        }
        var newMatrix = safeMatrix
        newMatrix[r][c] = true
        
        recursiveCheck(r: r + 1, c: c, rows: rows, cols: cols, safeMatrix: newMatrix)
        recursiveCheck(r: r - 1, c: c, rows: rows, cols: cols, safeMatrix: newMatrix)
        recursiveCheck(r: r, c: c + 1, rows: rows, cols: cols, safeMatrix: newMatrix)
        recursiveCheck(r: r, c: c - 1, rows: rows, cols: cols, safeMatrix: newMatrix)
    }
    
    func getNode(r: Int, c: Int) -> WoolThing{
        return woolNodesMatrix[r][c]!
    }

}
