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
        var scaleNum : Float = 0.13
        var positionY : Float = -200
        var level : Float = 0
        var speed: Float = 20
        
        for i in 0..<4 {
            let direction: Float = Bool.random() ? 1.0 : -1.0
            let positionX = Float.random(in: -400...400)
            let position = Vector2(x: positionX + level, y: positionY)
            let scale = Vector2(x: scaleNum, y: scaleNum)
            
            let sheep = WalkingSheep()
            sheep.zIndex = (Int32)((i) * 500 + 1)
            //sheep.configure(direction: direction, position: position, scale: scale, speed: speed)
            sheep.configure(sheepNum: i, direction: direction, position: position, scale: scale, speed: speed)
            GD.print("Spawned sheep num: \(sheep.sheepNum)")
            sheep.visible = true
            var num = String(i)
            self.addChild(node: sheep)
            sheep.setWalkNum(num: num)
            
            sheepList.append(sheep)
            
            scaleNum = scaleNum + 0.035
            positionY = positionY + 85
            level = level + 10
            speed = speed + 5.0
        }
        
        checkSavedSheep()
        
    }
    
    func checkSavedSheep() {
//        if SavedSheep.shared.hasSavedAppearance, let firstSheep = sheepList.first {
//            firstSheep.applySavedAppearance()
//        }
        for sheep in sheepList {
            if let appearance = SavedSheep.shared.appearance(for: sheep.sheepNum) {
                sheep.applySavedAppearance(appearance)
            }
        }
    }
}
