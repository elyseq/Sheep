//
//  WalkingSheepSpawner.swift
//  Sheep
//
//  Created by Maddy Scott on 3/31/26.
//

import SwiftGodot

@Godot
public class WalkingSheepSpawner: CharacterBody2D {
    
    //public var sheepList: [WalkingSheep] = []

    public override func _ready() {
        //for i in 0..<4 {
        let sheep = WalkingSheep()
        //sheep.position = Vector2(x: 800 + Float(i) * 150, y: 700)
        //sheep.position = Vector2(x: 800, y: 700)
        sheep.visible = true
        //sheep.scale = Vector2(x: 2, y: 2)
        self.addChild(node: sheep)
        //sheepList.append(sheep)
        //}
    }
}
