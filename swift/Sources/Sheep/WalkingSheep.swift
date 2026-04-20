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

    var speed: Float = 0
    var direction: Float = 0
    var animatedSprite: AnimatedSprite2D!
    //var path: String = "" // load a different sprite frame for each sheep to have them all start at different walking positions?
    
    override func _ready() {
        animatedSprite = AnimatedSprite2D()
        guard let frames = GD.load(path: "res://sheep_animations.tres") as? SpriteFrames else {
            // GD.load(path: "res://assets/" + path + ".tres") as? SpriteFrames else { load a different sprite frame for each sheep to have them all start at different walking positions?
            GD.print("Failed to load sprite frames")
            return
        }
        animatedSprite.spriteFrames = frames
        animatedSprite.play(name: "walk")
        self.addChild(node: animatedSprite)

        let collision = CollisionShape2D()
        let shape = RectangleShape2D()
        shape.size = Vector2(x: 275, y: 150)
        collision.shape = shape
        self.addChild(node: collision)
        
        
    }

    override func _physicsProcess(delta: Double) {
        if direction == 1 {
            animatedSprite?.flipH = true
        }
        
        velocity.y = 0
        velocity.x = speed * direction
        moveAndSlide()

        if isOnWall() {
            direction *= -1
            //direction *= -1
                        
                if direction == 1 {
                    animatedSprite?.flipH = true
                } else {
                    animatedSprite?.flipH = false
                }
        }
    }
    
    public func configure(direction: Float, position: Vector2, scale: Vector2, speed: Float) { // path: String
        self.direction = direction
        self.position = position
        self.scale = scale
        self.speed = speed
        //self.path = path // load a different sprite frame for each sheep to have them all start at different walking positions?
    }
}
