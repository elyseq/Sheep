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
    var animatedHead: AnimatedSprite2D!
    var animatedBody: AnimatedSprite2D!
    var woolLayer: Node2D = Node2D()
    var clickArea: Area2D = Area2D()
    var canClickSheep: Bool = true
    var sheepNum: Int = 0
    //var path: String = "" // load a different sprite frame for each sheep to have them all start at different walking positions?
    
    override func _ready() {
        guard let frames = GD.load(path: "res://sheep_animations.tres") as? SpriteFrames else {
            // GD.load(path: "res://assets/" + path + ".tres") as? SpriteFrames else { load a different sprite frame for each sheep to have them all start at different walking positions?
            GD.print("Failed to load sprite frames")
            return
        }
        
        animatedHead = AnimatedSprite2D()
        animatedHead.spriteFrames = frames
        animatedHead.play(name: "walkHead")
        animatedHead.zIndex = 250
        self.addChild(node: animatedHead)
        
        animatedBody = AnimatedSprite2D()
        animatedBody.spriteFrames = frames
        animatedBody.play(name: "walkBody")
        self.addChild(node: animatedBody)

        let collision = CollisionShape2D()
        let shape = RectangleShape2D()
        shape.size = Vector2(x: 275, y: 50)
        collision.shape = shape
        self.addChild(node: collision)
        self.addChild(node: woolLayer)
        
        let clickShape = CollisionShape2D()
        let clickRect = RectangleShape2D()
        clickRect.size = Vector2(x: 275, y: 150)
        clickShape.shape = clickRect

        clickArea.addChild(node: clickShape)
        clickArea.inputPickable = true
        self.addChild(node: clickArea)

//        clickArea.inputEvent.connect { viewport, event, shapeIdx in
//            if self.canClickSheep,
//               let mouseEvent = event as? InputEventMouseButton,
//               mouseEvent.pressed,
//               mouseEvent.buttonIndex == .left {
//                self.getTree()?.changeSceneToFile(path: "res://scene_barn.tscn")
//            }
//        }
        
        clickArea.inputEvent.connect { viewport, event, shapeIdx in
            if let mouseEvent = event as? InputEventMouseButton,
               mouseEvent.pressed,
               mouseEvent.buttonIndex == .left {

                SavedSheep.shared.selectedSheepNum = self.sheepNum
                GD.print("Clicked sheep num: \(self.sheepNum)")
                self.getTree()?.changeSceneToFile(path: "res://scene_barn.tscn")
            }
        }
        
        
    }

    override func _physicsProcess(delta: Double) {
        if direction == 1 {
            animatedHead?.flipH = true
            animatedBody?.flipH = true
            woolLayer.scale.x = -abs(woolLayer.scale.x)
        } else {
            animatedBody?.flipH = false
            animatedHead?.flipH = false
            woolLayer.scale.x = abs(woolLayer.scale.x)
        }
        
        velocity.y = 0
        velocity.x = speed * direction
        moveAndSlide()

        if isOnWall() {
            direction *= -1
            //direction *= -1
                        
                if direction == 1 {
                    animatedHead?.flipH = true
                    animatedBody?.flipH = true
                    woolLayer.scale.x = -abs(woolLayer.scale.x)
                    woolLayer.position = Vector2(x: -135, y: 50) //(x: -135, y: 100) //(x: -175, y: 100) //edit wool position, good direction when going to the right
                } else {
                    animatedBody?.flipH = false
                    animatedHead?.flipH = false
                    woolLayer.scale.x = abs(woolLayer.scale.x)
                    woolLayer.position = Vector2(x: 135, y: 50) //(x: 135, y: 100)
                }
        }
    }
    
    //public func configure(direction: Float, position: Vector2, scale: Vector2, speed: Float) { // path: String
    public func configure(sheepNum: Int, direction: Float, position: Vector2, scale: Vector2, speed: Float) {
        self.sheepNum = sheepNum
        self.direction = direction
        self.position = position
        self.scale = scale
        self.speed = speed
        //self.path = path // load a different sprite frame for each sheep to have them all start at different walking positions?
    }
    
    func clearSavedWoolOverlay() {
        for childIndex in stride(from: woolLayer.getChildCount() - 1, through: 0, by: -1) {
            woolLayer.getChild(idx: childIndex)?.queueFree()
        }
    }
    
    func applySavedAppearance(_ appearance: SheepAppearance) {
        let saved = SavedSheep.shared
        
//        if !saved.hasSavedAppearance {
//            return
//        }
        
        clearSavedWoolOverlay()
            
        //woolLayer.position = Vector2(x: 135, y: 100) //edit wool position, good direction when going to the right

        woolLayer.scale = Vector2(x: 1.3, y: 1.3)

        if(direction == 1) {
            woolLayer.position = Vector2(x: -135, y: 50)
        } else {
            woolLayer.position = Vector2(x: 135, y: 50)
        }
        
        for row in 0..<appearance.woolLocations.count {
            for col in 0..<appearance.woolLocations[row].count {
                let value = appearance.woolLocations[row][col]
                
                if value == "1" || value == "2" {
                    let woolWrapper = WoolThing()
                    let wool = woolWrapper.getChunk()
//                    wool.texture = GD.load(path: "res://assets/cloudshape.png") as? Texture2D
                    wool.position = Vector2(
                        x: Float(10 * col - 190),
                        y: Float(7 * row - 100)
                    )
                    wool.rotation = Double.random(in: 0.0...360.0)
                    wool.modulate = appearance.woolColors[row][col]
                    var centerVec = animatedBody.position
                    centerVec = centerVec + Vector2(x: -50, y: 40)
                    wool.zIndex = 200 - abs(Int32(wool.position.distanceTo(centerVec) + .random(in: -10 ... 10)))

                    if wool.position.y < -100 {
                        wool.zIndex = 500
                    }
                    woolLayer.addChild(node: wool)
                }
                
            }
            
        }
        
    }

    
}
