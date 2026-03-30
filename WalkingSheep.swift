//
//  WalkingSheep.swift
//  Sheep
//
//  Created by Maddy Scott on 3/30/26.
//
import SwiftGodot

@Godot
class Player: Node {
    
    @Export var speed: Float = 100.0
    var direction: Float = 1.0
    
    var body: CharacterBody2D?
    var animatedSprite: AnimatedSprite2D?
    
    override func _ready() {
        body = getParent() as? CharacterBody2D
        
        animatedSprite = body?.getNodeOrNull(path: "animatedSheep") as? AnimatedSprite2D
        
        animatedSprite?.play(name: "walk")
    }
    
    override func _physicsProcess(delta: Double) {
        guard let body = body else { return }
        
        body.velocity.x = speed * direction
        body.moveAndSlide()
        
        if body.isOnWall() {
            direction *= -1
            
            if direction < 0 {
                animatedSprite?.flipH = true
            } else {
                animatedSprite?.flipH = false
            }
        }
    }
}
