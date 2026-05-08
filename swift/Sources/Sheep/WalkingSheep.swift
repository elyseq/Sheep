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
    var shadow: Sprite2D!
    
    var woolLayer: Node2D = Node2D()
    var clickArea: Area2D = Area2D()
    var canClickSheep: Bool = true
    var sheepNum: Int = 0
    var isDragging: Bool = false
    var animationCooldown: Double = 0.0 // wait time
    
    override func _ready() {
        guard let frames = GD.load(path: "res://sheep_animations.tres") as? SpriteFrames else {
            GD.print("Failed to load sprite frames")
            return
        }
        
        // shadow
        shadow = Sprite2D()
        shadow.texture = GD.load(path: "res://assets/shadow.png") as? Texture2D
        shadow.position = Vector2(x:-250, y:650)
        shadow.scale = Vector2(x:1.25, y:0.7)
        shadow.modulate = Color(r: 0, g: 0, b: 0, a: 0.5)
        self.addChild(node: shadow)
        
        // head
        animatedHead = AnimatedSprite2D()
        animatedHead.spriteFrames = frames
        animatedHead.play(name: "walkHead")
        
        animatedHead.zIndex = 605
        animatedHead.scale = Vector2(x:1.78, y:1.78)
        animatedHead.position = Vector2(x:-183, y:7)
        self.addChild(node: animatedHead)
        
        // body
        animatedBody = AnimatedSprite2D()
        animatedBody.spriteFrames = frames
        animatedBody.play(name: "walk1")
        self.addChild(node: animatedBody)

        // collision box
        let collision = CollisionShape2D()
        let shape = RectangleShape2D()
        shape.size = Vector2(x: 275, y: 50)
        collision.shape = shape
        self.addChild(node: collision)
        self.addChild(node: woolLayer)
        
        // click box
        let clickShape = CollisionShape2D()
        let clickRect = RectangleShape2D()
        clickRect.size = Vector2(x: 800, y: 600)
        clickShape.shape = clickRect

        clickArea.addChild(node: clickShape)
        clickArea.inputPickable = true
        self.addChild(node: clickArea)
        
        // click handlers
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
//    override func _input(event: InputEvent) {
//        if event is InputEventMouseMotion && Input.isMouseButtonPressed(button: .left) {
//            isDragging = true
//        } else if event is InputEventMouseButton {
//            let mouseEvent = event as! InputEventMouseButton
//            if !mouseEvent.pressed {
//                isDragging = false
//            }
//        }
//    }
    override func _process(delta: Double) {
        
            animationCooldown -= delta
            
            if animationCooldown <= 0 {
                triggerRandomAnimation()
                animationCooldown = Double.random(in: 4.5...6.7)
            }
        
    }
    
    func triggerRandomAnimation() {
        let choice = Float.random(in: 0...1)
        
        if choice > 0.30 {
            playBlink()
        } else {
            playEarTwitch()
        }
    }
    
    func playBlink() {
        animatedHead?.play(name: "blink")
    }

    func playEarTwitch() {
        animatedHead?.play(name: "twitch")
    }
    
    override func _physicsProcess(delta: Double) {
        // changes direction if hits fence
        if direction == 1 {
            animatedHead?.flipH = true
            animatedBody?.flipH = true
            animatedHead?.position = Vector2(x:-183, y: 7)
            shadow.position = Vector2(x:-250, y:650)

            woolLayer.scale.x = -abs(woolLayer.scale.x)
        } else {
            animatedBody?.flipH = false
            animatedHead?.flipH = false
            animatedHead?.position = Vector2(x:183, y: 7)
            shadow.position = Vector2(x:250, y:650)
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
                    woolLayer.position = Vector2(x: -200, y: 8)
                } else {
                    animatedBody?.flipH = false
                    animatedHead?.flipH = false
                    woolLayer.scale.x = abs(woolLayer.scale.x)
                    woolLayer.position = Vector2(x: 200, y: 8)
                }
        }
    }
    
    
    public func configure(sheepNum: Int, direction: Float, position: Vector2, scale: Vector2, speed: Float) {
        self.sheepNum = sheepNum
        self.direction = direction
        self.position = position
        self.scale = scale
        self.speed = speed
    }
    
    func clearSavedWoolOverlay() {
        for childIndex in stride(from: woolLayer.getChildCount() - 1, through: 0, by: -1) {
            woolLayer.getChild(idx: childIndex)?.queueFree()
        }
    }
    
    func setWalkNum(num: String){
        // sets the correct walk animation so sheep all start at different walk cycles
        guard let animatedBody = animatedBody else {
                GD.print("setWalkNum called before _ready")
                return
            }
        let walkNum = "walk" + num
        animatedBody.play(name: StringName(walkNum))
    }
    
    func applySavedAppearance(_ appearance: SheepAppearance) {
        // applies the edits to sheep
        
        let saved = SavedSheep.shared
        clearSavedWoolOverlay()
            
        //woolLayer.position = Vector2(x: 135, y: 100) //edit wool position, good direction when going to the right

        woolLayer.scale = Vector2(x: 1.75, y: 1.75)

        if(direction == 1) {
            woolLayer.position = Vector2(x: -200, y: 8)
        } else {
            woolLayer.position = Vector2(x: 200, y: 8)
        }
        
        for row in 0..<appearance.woolLocations.count {
            for col in 0..<appearance.woolLocations[row].count {
                let value = appearance.woolLocations[row][col]
                
                if value == "1" || value == "2" {
                    let woolWrapper = WoolThing()
                    let wool = woolWrapper.getChunk()
//                    wool.texture = GD.load(path: "res://assets/cloudshape.png") as? Texture2D
                    wool.position = Vector2(
                        x: Float(28 * col - x_displacement),
                        y: Float(20 * row - y_displacement)
                    )
                    wool.rotation = Double.random(in: 0.0...360.0)
                    wool.modulate = appearance.woolColors[row][col]
                    var centerVec = animatedBody.position
                    centerVec = centerVec + Vector2(x: -50, y: 40)
                    wool.zIndex = 600 - abs(Int32(wool.position.distanceTo(centerVec) + .random(in: -10 ... 10)))

                    if wool.position.y < -220 {
                        wool.zIndex = 700
                    }
                    woolLayer.addChild(node: wool)
                }
                
            }
            
        }
        
    }

    func applyDefaultAppearance() {
        let locations = SavedSheep.shared.readFile(fileName: "sheepmatrix.txt")
        var colors: [[Color]] = []

        for row in locations {
            colors.append(
                row.map { value in
                    value == "1" || value == "2"
                    ? Color(r: 1, g: 1, b: 1)
                    : Color(r: 0, g: 0, b: 0, a: 0)
                }
            )
        }

        applySavedAppearance(
            SheepAppearance(
                woolLocations: locations,
                woolColors: colors
            )
        )
    }
    
}
