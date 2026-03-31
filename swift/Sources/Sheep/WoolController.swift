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
    override func _ready() {
        // Sheep Body
        let sheepbody = Sprite2D()
        sheepbody.texture = GD.load(path: "res://assets/sheepBody.png") as? Texture2D
        sheepbody.position = Vector2(x: 1000, y: 700)
        sheepbody.scale = Vector2(x: 2, y: 2)
        addChild(node:sheepbody)
        
//        let sheepsprite = Sprite2D()
//        sheepsprite.texture = GD.load(path: "res://assets/TransparentSheep.png") as? Texture2D
//        sheepsprite.position = Vector2(x: 500, y: 500)
//        sheepsprite.scale = Vector2(x: 1.5, y: 1.5)
//        addChild(node:sheepsprite)
        
        // Wool
        let woolLocations = readFile(fileName: "sheepmatrix.txt")
        for y in 0...woolLocations.count-1{
            let ypos = 10 * y - 220
            for x in 0...woolLocations[y].count-1{
                let xpos = 10 * x - 160
                if(woolLocations[y][x] == "1"){
                    let wool = makeWoolNode(Vector2(x: Float(xpos), y: Float(ypos)))
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
