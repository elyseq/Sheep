//
//  PlayerController.swift
//  Sheep
//
//  Created by Elyse Q on 3/10/26.
//

import SwiftGodot

@Godot
class PlayerController: CharacterBody2D {
    var acceleration: Float = 2000
    var friction: Double = 10
    var speed: Double = 2000
    
    var movementVector: Vector2 {
        var movement = Vector2.zero
        movement.x = Float(
            Input.getActionStrength(action: "move_right") - Input.getActionStrength(action: "move_left"))
        return movement.normalized()
    }
    
    override func _physicsProcess(delta: Double) {
        if Engine.isEditorHint() { return }
        if movementVector != .zero {
            let acceleratedVector = Vector2(x: acceleration, y: acceleration)
            let acceleratedMovement = movementVector * acceleratedVector
            self.velocity = acceleratedMovement.limitLength(speed)
        } else {
                    velocity = velocity.moveToward(to: .zero, delta: friction)
        }
        self.moveAndSlide()
    }
}
