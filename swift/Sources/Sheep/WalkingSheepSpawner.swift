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
//        //1 SHEEP (WORKING)
//        //for i in 0..<4 {
//            let sheep = WalkingSheep()
//            //sheep.position = Vector2(x: 800 + Float(i) * 150, y: 700) //doesn't work
//            //sheep.position = Vector2(x: 800, y: 700) //doesn't work
//            //sheep.position = Vector2(x: 1300, y: 700) //doesn't work
//            //sheep.position = Vector2(x: Float(i) * 150, y: Float(i) * 50)
//            sheep.position = Vector2(x: 0, y: 0) //WORKS
//            sheep.visible = true
//            sheep.scale = Vector2(x: 0.7, y: 0.7)
//            self.addChild(node: sheep)
//            //sheepList.append(sheep)
//            GD.print("sheep added")
//        //}
        
        //ARRAY OF SHEEP (WORKING, looks off)
        for i in 0..<4 {
            let sheep = WalkingSheep()
            //sheep.position = Vector2(x: 800 + Float(i) * 150, y: 700) //doesn't work
            //sheep.position = Vector2(x: 800, y: 700) //doesn't work in array
            //sheep.position = Vector2(x: 1300, y: 700) //doesn't work in array
            sheep.position = Vector2(x: Float(i) * 150, y: Float(i) * 50)
            sheep.visible = true
            sheep.scale = Vector2(x: 0.7, y: 0.7)
            self.addChild(node: sheep)
            sheepList.append(sheep)
            GD.print("sheep added")
        }
        
        //ARRAY OF SHEEP RANDOM POINT (NOT WORKING)
//        for i in 0..<4 {
//            let sheep = WalkingSheep()
//
//            sheep.position = Vector2(x: 800, y: 500 //these points don't work (was using to test range)
//                //x: Float.random(in: 300...800), //wrong range
//                //y: Float.random(in: 0...1) //wrong range
//            )
//            
//            sheep.visible = true
//            sheep.scale = Vector2(x: 0.7, y: 0.7)
//            addChild(node: sheep)
//            sheepList.append(sheep)
//            GD.print("sheep added")
//        }
    }
}
