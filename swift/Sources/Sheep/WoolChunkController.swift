//
//  WoolChunkController.swift
//  Sheep
//
//  Created by Nora Betry on 3/13/26.
//
import SwiftGodot

@Godot
class WoolChunkController: Area2D {
    
    override func _ready() {
        let sprite = Sprite2D()
        sprite.texture = GD.load(path: "res://assets/cloudshape.png") as? Texture2D
        sprite.scale = Vector2(x: 0.01, y: 0.01)
        addChild(node: sprite)
        
        let collision = CollisionShape2D()
        let circle = CircleShape2D()
        circle.radius = 10 //copied this from another example idk what this is doing tbh
        collision.shape = circle
        addChild(node: collision)
        
        self.inputPickable = true
        self.mouseEntered.connect(onMouseEntered)
    }
    
    func onMouseEntered() {
            // Check if the left mouse button is held down while entering
            if Input.isMouseButtonPressed(button: .left) {
                queueFree()
            }
        }

}
