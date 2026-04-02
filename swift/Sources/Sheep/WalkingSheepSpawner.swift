//
//  WalkingSheepSpawner.swift
//  Sheep
//
//  Created by Maddy Scott on 3/31/26.
//

import SwiftGodot

@Godot
public class WalkingSheepSpawner: CharacterBody2D {
    
    var sheepList: [WalkingSheep] = []
    
    public override func _ready() {
        //ARRAY OF SHEEP
        var scaleNum : Float = 0.4
        var positionY : Float = -200
        var level : Float = 0
        var speed: Float = 50
        
        for i in 0..<4 {
            let direction: Float = Bool.random() ? 1.0 : -1.0
            let positionX = Float.random(in: -400...400)
            let position = Vector2(x: positionX + level, y: positionY)
            let scale = Vector2(x: scaleNum, y: scaleNum)
            let sheep = WalkingSheep()
            sheep.configure(direction: direction, position: position, scale: scale, speed: speed)
            sheep.visible = true
            self.addChild(node: sheep)
            sheepList.append(sheep)
<<<<<<< HEAD
            
=======
            GD.print("sheep added")
>>>>>>> cbee62e5b6acb786c703a60595162844b130f766
            scaleNum = scaleNum + 0.1
            positionY = positionY + 100
            level = level + 10
            speed = speed + 13.5
        }
    }
}
