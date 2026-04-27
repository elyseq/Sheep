//
//  WoolChunkController.swift
//  Sheep
//
//  Created by Nora Betry on 3/13/26.
//
import SwiftGodot

@Godot
class WoolChunkController: Area2D {
    var shadowSprite: Sprite2D = Sprite2D() // Store the black wool here
    var sprite : Sprite2D = Sprite2D()
    var player: AudioStreamPlayer!
    var collision = CollisionShape2D()
    override func _ready() {
        player = AudioStreamPlayer()
        addChild(node: player)
        player.stream = GD.load(path: "res://assets/shearingSound.mp3")
        player.volumeDb = -65.0
        player.play()
        player.streamPaused = true
        sprite.texture = GD.load(path: "res://assets/cloudshape.png") as? Texture2D
        sprite.scale = Vector2(x: 0.07, y: 0.07)
        
        shadowSprite.texture = GD.load(path: "res://assets/cloudshape.png") as? Texture2D
        shadowSprite.scale = Vector2(x: 0.08, y: 0.08)

        
        sprite.modulate = Color(r: 0.965, g: 0.945, b: 0.898) // makes clouds/wool the color of head
        shadowSprite.modulate = Color(r:0.0, g: 0.0, b: 0.0)
        shadowSprite.zIndex = 1
        sprite.zIndex = 50
        addChild(node: sprite)
        addChild(node: shadowSprite)
        
        let circle = CircleShape2D()
        circle.radius = 7 //changes brush size!
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
    func changeCollisionSize(value: Double) {
        let circle = CircleShape2D()
        circle.radius = value //changes brush size!
        collision.shape = circle
    }
    override func _input(event: InputEvent?) {
            guard let mouseEvent = event as? InputEventMouseButton else { return }
            
            if mouseEvent.isPressed() && mouseEvent.buttonIndex == .left {
                guard let woolThing = self.getParent() as? WoolThing else {
                    return
                }
                guard let woolController = woolThing.getParent()?.getParent() as? WoolController else {
                    GD.print("Could not find WoolController")
                    return
                }

                if woolController.selectedFunction == .shave {
                    player.streamPaused = false
                }
            }
        if !mouseEvent.isPressed(){
            
            player.streamPaused = true
        }
            
    }
   
    func setColor(_ color: Color) {
        sprite.modulate = color
    }
    func getColor() -> Color {
        return sprite.modulate
    }
    
    func onMouseEntered() {
        // Check if the left mouse button is held down while entering
        if Input.isMouseButtonPressed(button: .left) {

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
    }
    
    private func shave() {
        guard let tween = createTween() else {
            GD.print("Could not create tween")
            return
        }
        
        // Animate wool flying away

        var xMovement:Float = Float(Bool.random() ? Double.random(in: -120 ... -30) : Double.random(in: 30 ... 120))
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

        // Remove wool chunk when animation finished

        tween.finished.connect {
            guard let woolThing = self.getParent() as? WoolThing else { return }
                
            guard let woolController = woolThing.getParent()?.getParent() as? WoolController else {
                GD.print("Could not find WoolController")
                return
            }

            let row = Int((woolThing.position.y + 150) / 7)
            let col = Int((woolThing.position.x + 195) / 10)

            woolController.woolLocations[row][col] = "0"
            woolController.woolNodesMatrix[row][col] = nil
            woolController.checkForFloating(row: row, col: col)
            self.shadowSprite.queueFree()
            self.queueFree()
            woolThing.queueFree() // Remove the parent wrapper as well
        }

    }
}
