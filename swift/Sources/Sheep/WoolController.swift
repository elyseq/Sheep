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
        // Sheep Body
        let sheepbody = Sprite2D()
        sheepbody.texture = GD.load(path: "res://assets/sheepBody.png") as? Texture2D
        sheepbody.position = Vector2(x: 1000, y: 700)
        sheepbody.scale = Vector2(x: 2, y: 2)
        addChild(node:sheepbody)
        
        // Wool
        self.woolLocations = readFile(fileName: "sheepmatrix.txt")
        for y in 0...woolLocations.count-1{
            woolNodesMatrix.append(Array(repeating: nil, count: woolLocations[y].count))
            let ypos = 10 * y - 130
            for x in 0...woolLocations[y].count-1{
                let xpos = 10 * x - 180
                if(woolLocations[y][x] == "1"){
                    let wool = makeWoolNode(Vector2(x: Float(xpos), y: Float(ypos)))
                    woolNodesMatrix[y][x] = wool as? WoolThing
                    sheepbody.addChild(node: wool)
                }
                
            }
        
        }
        
        // Sheep Head
        let sheephead = Sprite2D()
        sheephead.texture = GD.load(path: "res://assets/sheepHead.png") as? Texture2D
        sheephead.position = Vector2(x: 1000, y: 700)
        sheephead.scale = Vector2(x: 2, y: 2)
        addChild(node:sheephead)
    }
    func makeWoolNode (_ pos: Vector2) -> Node {
        let n = WoolThing()
        n.position = pos
        n.rotation = Double.random(in:0.0...360.0)
        return n
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
    func checkForFloating(row: Int,col: Int){
        let rows = woolLocations.count
        let cols = woolLocations[0].count
        var safeMatrix: [[Bool]] = Array(repeating: Array(repeating: false, count: cols), count: rows)
        
        for r in 0..<rows{
            for c in 0..<cols{
                if woolLocations[r][c] == "1" {
                                // If it's skin, it's safe, and so is all wool touching it
                                recursiveCheck(r: r, c: c, rows: rows, cols: cols, safeMatrix: &safeMatrix)
                            
                }
            }
        }
        
        for r in 0..<rows{
            for c in 0..<cols{
                if(woolLocations[r][c] == "2" && !safeMatrix[r][c]){
                    woolLocations[r][c] = "0"
                    if let node = woolNodesMatrix[r][c] {
                        GD.print(woolNodesMatrix)
                        node.queueFree()
                        woolNodesMatrix[r][c] = nil
                    }
                }
            }
            
        }
    }
        
    
    
    func recursiveCheck(r: Int, c: Int, rows: Int, cols: Int, safeMatrix: inout [[Bool]]){
        if (r < 0 || r >= rows || c < 0 || c >= cols || safeMatrix[r][c] || woolLocations[r][c] != "2"){
            return

        }
        
        safeMatrix[r][c] = true
        
        recursiveCheck(r: r + 1, c: c, rows: rows, cols: cols, safeMatrix: &safeMatrix)
        recursiveCheck(r: r - 1, c: c, rows: rows, cols: cols, safeMatrix: &safeMatrix)
        recursiveCheck(r: r, c: c + 1, rows: rows, cols: cols, safeMatrix: &safeMatrix)
        recursiveCheck(r: r, c: c - 1, rows: rows, cols: cols, safeMatrix: &safeMatrix)

    }
    
    func getNode(r: Int, c: Int) -> WoolThing{
        return woolNodesMatrix[r][c]!
    }

}
