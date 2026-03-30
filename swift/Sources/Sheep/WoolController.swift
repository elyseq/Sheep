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

@Godot
class WoolController: CharacterBody2D {
    override func _ready() {
        let sheepsprite = Sprite2D()
        sheepsprite.texture = GD.load(path: "res://assets/TransparentSheep.png") as? Texture2D
        sheepsprite.position = Vector2(x: 500, y: 500)
        addChild(node:sheepsprite)
        for y in 10...20 {
            for i in 1...50 {
                let wool = makeWoolNode(Vector2(x: Float((10*i)), y: Float(10*y)))
                    sheepsprite.addChild(node: wool)
            }
            
            
        }
    }
}
