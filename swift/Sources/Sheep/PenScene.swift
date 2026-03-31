//
//  PenScene.swift
//  Sheep
//
//  Created by Maddy Scott on 3/31/26.
//
import SwiftGodot

@Godot
final class PenScene: Node2D {
    
    public var sheepList: [WalkingSheep] = []

    override func _ready() {

        for i in 0..<4 {
            let sheep = WalkingSheep()
            sheep.position = Vector2(x: 800 + Float(i) * 150, y: 700)
            sheep.scale = Vector2(x: 2, y: 2)
            addChild(node: sheep)
            sheepList.append(sheep)
        }
    }
}
