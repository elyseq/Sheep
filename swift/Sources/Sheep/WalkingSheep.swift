//
//  WalkingSheep.swift
//  Sheep
//
//  Created by Maddy Scott on 3/30/26.
//
//
import SwiftGodot

@Godot
class WalkingSheep: CharacterBody2D {

    var speed: Float = 80.0
    var direction: Float = -1.0

    var animatedSprite: AnimatedSprite2D!

    override func _ready() {
        animatedSprite = AnimatedSprite2D()
        guard let frames = GD.load(path: "res://assets/sheep_frames.tres") as? SpriteFrames else {
            GD.print("Failed to load sprite frames")
            return
        }
        animatedSprite.spriteFrames = frames
        animatedSprite.play(name: "walk")
        self.addChild(node: animatedSprite)

        let collision = CollisionShape2D()
        let shape = RectangleShape2D()
        shape.size = Vector2(x: 300, y: 300)
        collision.shape = shape
        self.addChild(node: collision)
    }

    override func _physicsProcess(delta: Double) {
        velocity.x = speed * direction
        moveAndSlide()

        if isOnWall() {
            direction *= 1
            animatedSprite.flipH = direction < 0
        }
    }
}
