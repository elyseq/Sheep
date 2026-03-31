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
            guard let tween = createTween() else {
                GD.print("Could not create tween")
                return
            }
//            tween.tweenProperty(object: self, property: "scale", finalVal: Variant(Vector2(x: 0, y: 0)), duration: 0.3)?
//                .setTrans(.back)?
//                .setEase(.in)
//            tween.parallel()?.tweenProperty(object: self, property: "modulate", finalVal: Variant(Color(r: 1, g: 1, b: 1, a: 0)), duration: 1)
//            
//            tween.tweenProperty(object: self, property: "position", finalVal: Variant(Vector2(x: self.position.x+100, y: self.position.y+100)), duration: 0.5)
//            tween.tweenProperty(object: self, property: "position", finalVal: Variant(Vector2(x: self.position.x+150, y: self.position.y+150)), duration: 0.5)
//            tween.parallel()?.tweenProperty(object: self, property: "scale", finalVal: Variant(Vector2(x: 0, y: 0)), duration: 0.3)?
//                           .setTrans(.back)?
//                          .setEase(.in)
            var xMovement:Float = Float(Bool.random() ? Double.random(in: -110 ... -90) : Double.random(in: 90 ... 110))
            tween.tweenProperty(object: self, property: "global_position", finalVal: Variant(Vector2(x: self.globalPosition.x + xMovement, y: self.globalPosition.y-60)), duration: 0.18)
            tween.parallel()?.tweenProperty(object: self, property: "rotation", finalVal: Variant(self.rotation+3.14), duration: 0.18)
            if xMovement > 0 {
                tween.tweenProperty(object: self, property: "global_position", finalVal: Variant(Vector2( x: self.globalPosition.x + Float(Double.random(in: 190 ... 210)), y: self.globalPosition.y+220)), duration: 0.55)
            } else {
                tween.tweenProperty(object: self, property: "global_position", finalVal: Variant(Vector2( x: self.globalPosition.x + Float(Double.random(in: -210 ... -190)), y: self.globalPosition.y+220)), duration: 0.55)
            }
           

            tween.parallel()?.tweenProperty(object: self, property: "rotation", finalVal: Variant(self.rotation+18.84954), duration: 1)

            tween.parallel()?.tweenProperty(object: self, property: "scale", finalVal: Variant(Vector2(x: 0, y: 0)), duration: 0.73)?
                           .setTrans(.back)?
                           .setEase(.in)

            tween.finished.connect {
                self.queueFree()
            }
        }
    }

}
