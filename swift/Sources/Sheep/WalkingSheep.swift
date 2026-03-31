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
    var direction: Float = 1.0
    
    var body: CharacterBody2D!

    private var animatedSprite: AnimatedSprite2D!

    override func _ready() {
        GD.print("WalkingSheep ready")

        animatedSprite = AnimatedSprite2D()
        let frames = GD.load(path: "res://assets/sheep_frames.tres") as? SpriteFrames
        animatedSprite.spriteFrames = frames
        animatedSprite.play(name: "walk")
        body.addChild(node: animatedSprite)

        let collision = CollisionShape2D()
        let shape = RectangleShape2D()
        shape.size = Vector2(x: 40, y: 24)
        collision.shape = shape
        body.addChild(node: collision)
    }

    override func _physicsProcess(delta: Double) {
        velocity.x = speed * direction
        moveAndSlide()

        if isOnWall() {
            direction *= -1
            animatedSprite.flipH = direction < 0
        }
    }
}
