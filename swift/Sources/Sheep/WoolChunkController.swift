///
///  WoolChunkController.swift
///  Sheep
///
///  Created by Nora Betry on 3/13/26.
///
///  Manages each individual wool particle, it's collision size, and the functionality and animation of
///  each peice being sheared.
///

import SwiftGodot
let y_displacement = 365
let x_displacement = 320

@Godot
class WoolChunkController: Area2D {
    var shadowSprite: Sprite2D = Sprite2D()
    var sprite : Sprite2D = Sprite2D()
    var collision = CollisionShape2D()
    override func _ready() {
        sprite.texture = GD.load(path: "res://assets/cloudshape.png") as? Texture2D
        sprite.scale = Vector2(x: 0.2, y: 0.2)
        sprite.zIndex = 50

        shadowSprite.texture = GD.load(path: "res://assets/cloudshape.png") as? Texture2D
        shadowSprite.scale = Vector2(x: 0.23, y: 0.23)
        shadowSprite.modulate = Color(r:0.0, g: 0.0, b: 0.0)
        shadowSprite.zIndex = 1
        
        addChild(node: sprite)
        addChild(node: shadowSprite)
        
        let circle = CircleShape2D()
        circle.radius = 7
        collision.shape = circle
        addChild(node: collision)
        
        self.inputPickable = true
        self.mouseEntered.connect(onMouseEntered)
    }
    
    func getSprite() -> Sprite2D? {
        return(sprite)
    }
    
    func getShadowSprite() -> Sprite2D? {
        return(shadowSprite)
    }
    
    /// Changes brush size
    func changeCollisionSize(value: Double) {
        let circle = CircleShape2D()
        circle.radius = value
        collision.shape = circle
    }
    
    /// Shears/colors chunk of wool on mouse left click
    override func _inputEvent(viewport: Viewport?, event: InputEvent?, shapeIdx: Int32) {
          guard let mouseEvent = event as? InputEventMouseButton else { return }
        
          if mouseEvent.buttonIndex == .left && mouseEvent.pressed {
              woolSheared()
          }
    }
   
    func setColor(_ color: Color) {
        sprite.modulate = color
    }
    
    func getColor() -> Color {
        return sprite.modulate
    }
 
    /// Shears/colors chunk of wool on left mouse drag
    func onMouseEntered() {
        if Input.isMouseButtonPressed(button: .left) {
           woolSheared()
        }
    }
    
    /// Initiates wool shaving/coloring fuctions depending on mode
    func woolSheared(){
        guard let woolThing = self.getParent() as? WoolThing,
              let woolController = woolThing.getParent()?.getParent() as? WoolController
        else {
            GD.print("Could not find WoolController")
            return
        }
        
        switch woolController.selectedFunction {
        case .color:
            sprite.modulate = woolController.selectedColor

        case .shave:
            shave()
        
        case .normal:
            return
        }
    }
    
    /// Completes the wool flying animation using tweens, then removes the chunk from its respective stored locations
    private func shave() {
        guard let tween = createTween() else {
            GD.print("Could not create tween")
            return
        }
        
        var xMovement:Float = Float(Bool.random() ? Double.random(in: -120 ... -30) : Double.random(in: 30 ... 120))
        tween.tweenProperty(object: self, property: "global_position", finalVal: Variant(Vector2(x: self.globalPosition.x + xMovement, y: self.globalPosition.y-60)), duration: 0.18)
        tween.parallel()?.tweenProperty(object: self, property: "rotation", finalVal: Variant(self.rotation+3.14), duration: 0.18)
        if xMovement > 0 {
            tween.tweenProperty(object: self, property: "global_position", finalVal: Variant(Vector2( x: self.globalPosition.x + Float(Double.random(in: 190 ... 210)), y: self.globalPosition.y+220)), duration: 0.55)

        }
        else {
            tween.tweenProperty(object: self, property: "global_position", finalVal: Variant(Vector2( x: self.globalPosition.x + Float(Double.random(in: -210 ... -190)), y: self.globalPosition.y+220)), duration: 0.55)
        }

        tween.parallel()?.tweenProperty(object: self, property: "rotation", finalVal: Variant(self.rotation+18.84954), duration: 1)

        tween.parallel()?.tweenProperty(object: self, property: "scale", finalVal: Variant(Vector2(x: 0, y: 0)), duration: 0.73)?
                       .setTrans(.back)?
                       .setEase(.in)

        tween.finished.connect {
            guard let woolThing = self.getParent() as? WoolThing else { return }
                
            guard let woolController = woolThing.getParent()?.getParent() as? WoolController else {
                GD.print("Could not find WoolController")
                return
            }

            let row = ((Int(woolThing.position.y) + y_displacement) / 20)
            let col = (Int(woolThing.position.x) + x_displacement)  / 28

            woolController.woolLocations[row][col] = "0"
            woolController.woolNodesMatrix[row][col] = nil
            woolController.checkForFloating(row: row, col: col)
            self.shadowSprite.queueFree()
            self.queueFree()
            woolThing.queueFree()
        }
    }
}
