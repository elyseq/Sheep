///
///  WoolController.swift
///  Sheep
///
///  Created by Nora Betry on 3/11/26.
///
///  Contains logic for building complete wool layer on sheep, composed of many wool particles.
///  Manages face animation, sound effects, and setting modes / redo in the barn.
///

import SwiftGodot
import Foundation

@Godot
class WoolController: CharacterBody2D {
    var woolLocations: [[String]] = []
    var woolNodesMatrix : [[WoolChunkController?]] = []
    
    var selectedFunction : MouseMode = .normal
    var selectedColor: Color = Color(r: 0.0, g: 0.0, b: 0.0, a: 0.0)
    var player: AudioStreamPlayer = AudioStreamPlayer()

    var sheepbody = Sprite2D()
    
    var animatedSprite: AnimatedSprite2D = AnimatedSprite2D()
    var isDragging: Bool = false
    var animationCooldown: Double = 0.0 // wait time
    
    override func _ready() {
        setNormalMode()
        
        sheepbody = makeSheepBody()
        addChild(node:sheepbody)

        placeSheepWool(mode: "normal")
    
        guard let frames = GD.load(path: "res://sheep_animations.tres") as? SpriteFrames else {
            GD.print("Failed to load sprite frames")
            return
        }
        animatedSprite = makeAnimatedSprite(frames: frames)
        addChild(node: animatedSprite)
        
        addChild(node: player)
        player.volumeDb = -15.0

        player.stream = GD.load(path: "res://assets/shearingSound.mp3")
        player.play(fromPosition: 5.0)
        player.streamPaused = true
    }
    
    /// Creates and returns the sheep body sprite, scales and positions
    func makeSheepBody() -> Sprite2D{
        let sbody = Sprite2D()
        sbody.texture = GD.load(path: "res://assets/body.png") as? Texture2D
        sbody.position = Vector2(x: 950, y: 750) // +75
        sbody.scale = Vector2(x: 0.7, y: 0.7)
        sbody.zIndex = 1
        return sbody
    }
    
    /// Places sheep wool according to locations matrix, randomizing rotation and sorting z index based on distance from center.
    /// Preserves saved sheep design if applicable.
    func placeSheepWool(mode: String) {
        if let appearance = SavedSheep.shared.appearanceForSelectedSheep() {
            self.woolLocations = appearance.woolLocations
        } else {
            self.woolLocations = SavedSheep.shared.readFile(fileName: "sheepmatrix.txt")
        }
        
        if(mode == "redo"){
            self.woolLocations = SavedSheep.shared.readFile(fileName: "sheepmatrix.txt")
        }
        
        for y in 0...woolLocations.count-1{
            woolNodesMatrix.append(Array(repeating: nil, count: woolLocations[y].count))
            let ypos = (20 * y - y_displacement)
            for x in 0...woolLocations[y].count-1{
                let xpos = (28 * x - x_displacement)
                if(woolLocations[y][x] == "1" || woolLocations[y][x] == "2"){
                    let woolWrapper = WoolThing()
                    woolWrapper.position = Vector2(x: Float(xpos), y: Float(ypos))
                    woolWrapper.rotation = Double.random(in: 0.0...360.0)
                    
                    let distToCenter = woolWrapper.position.distanceTo(Vector2(x: 45, y: 15)) + .random(in: -10 ... 10)
                    woolWrapper.zIndex = 600 - abs(Int32(distToCenter))
                    if(woolWrapper.position.y < -220){
                        woolWrapper.zIndex = 700
                    }
                    let wool = woolWrapper.getChunk()
                    
                    woolNodesMatrix[y][x] = wool as? WoolChunkController
                    sheepbody.addChild(node: woolWrapper)
                    
                    if(mode != "redo"){
                        if let appearance = SavedSheep.shared.appearanceForSelectedSheep(),
                           y < appearance.woolColors.count,
                           x < appearance.woolColors[y].count {
                            wool.setColor(appearance.woolColors[y][x])
                        }
                    }
                   
                }
            }
        }
    }
    
    /// Creates and returns the animated sheep head.
    func makeAnimatedSprite(frames: SpriteFrames) -> AnimatedSprite2D {
        
        let aSprite = AnimatedSprite2D()
        aSprite.position = Vector2(x: 950, y: 750)
        aSprite.scale = Vector2(x: 0.7, y: 0.7)
        aSprite.spriteFrames = frames
        aSprite.zIndex = 650
        aSprite.play(name: "none")
        return aSprite
    }
    
    
    func makeWoolNode (_ pos: Vector2) -> WoolChunkController {
        let n = WoolThing()
        n.position = pos
        return n.getChunk()
    }
    
    /// Initiates facial animation on drag
    override func _process(delta: Double) {
        if isDragging {
            animationCooldown -= delta
            
            if animationCooldown <= 0 {
                triggerRandomAnimation()
                animationCooldown = Double.random(in: 0.75...1.75)
            }
        }
    }
    
    /// Determines if isDragging, and when shaving plays shave sound effect.
    override func _input(event: InputEvent) {
        if event is InputEventMouseMotion && Input.isMouseButtonPressed(button: .left) {
            isDragging = true
        } else if event is InputEventMouseButton {
            let mouseEvent = event as! InputEventMouseButton
            if !mouseEvent.pressed {
                isDragging = false
            }
        }
        
        guard let mouseEvent = event as? InputEventMouseButton else { return }
        
        if mouseEvent.isPressed() && mouseEvent.buttonIndex == .left {
            if selectedFunction == .shave {
                player.streamPaused = false
            }
        }
        if !mouseEvent.isPressed(){
            player.streamPaused = true
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
        animatedSprite.play(name: "blink")
    }

    func playEarTwitch() {
        animatedSprite.play(name: "twitch")
    }
    
    /// Checks wool locations matrix for "floating" wool -- that which is not attatched to the body.
    /// This translates to "2"s that are not connected to "1"s in the matrix.
    func checkForFloating(row: Int,col: Int){
        let rows = woolLocations.count
        let cols = woolLocations[0].count
        var safeMatrix: [[Bool]] = Array(repeating: Array(repeating: false, count: cols), count: rows)
        
        for r in 0..<rows{
            for c in 0..<cols{
                if woolLocations[r][c] == "1" {
                    recursiveCheck(r: r, c: c, rows: rows, cols: cols, safeMatrix: &safeMatrix)
                    
                }
            }
        }
        
        animateFloatingDisappear(safeMatrix: safeMatrix)
    }
    
    /// Animates the floating wool's disappearance.
    func animateFloatingDisappear(safeMatrix: [[Bool]]) {
        let rows = woolLocations.count
        let cols = woolLocations[0].count
        for r in 0..<rows {
            for c in 0..<cols {
                if woolLocations[r][c] == "2" && !safeMatrix[r][c] {
                    GD.print("in first loop")
                    
                    woolLocations[r][c] = "0"
                    GD.print("Done")
                    GD.print(woolNodesMatrix[r][c])
                    if let node = woolNodesMatrix[r][c] {
                        GD.print("trying to queue free")
                        let tween = createTween()
                        tween?.tweenProperty(object: node.getSprite(), property: "scale", finalVal: Variant(Vector2(x: 0.14,y: 0.15)), duration: 0.1)
                        tween?.tweenProperty(object: node, property: "rotation", finalVal: Variant(Bool.random() ? node.rotation+3*3.14 : node.rotation-3*3.14), duration: 0.5)
                        tween?.parallel()?.tweenProperty(object: node.shadowSprite, property: "modulate", finalVal: Variant(Color(r: 1, g: 1, b: 1, a: 0)), duration: 0.1 )
                        tween?.parallel()?.tweenProperty(object: node, property: "modulate", finalVal: Variant(Color(r: 1, g: 1, b: 1, a: 0)), duration: Double.random(in: 0.5 ... 1.0) )
                        tween?.parallel()?.tweenProperty(object: node, property: "scale", finalVal: Variant(Vector2(x: 0.5,y: 0.5)), duration: 0.3)
                    }
                    woolNodesMatrix[r][c] = nil
                }
            }
        }
    }
    
    /// Recursive checking helper method for checking for floating wool.
    func recursiveCheck(r: Int, c: Int, rows: Int, cols: Int, safeMatrix: inout [[Bool]]){
        if (r < 0 || r >= rows || c < 0 || c >= cols || safeMatrix[r][c]){
            return
            
        }
        if (safeMatrix[r][c]) { return }
        
        if (woolLocations[r][c] == "0") { return }
        
        safeMatrix[r][c] = true
        
        recursiveCheck(r: r + 1, c: c, rows: rows, cols: cols, safeMatrix: &safeMatrix)
        recursiveCheck(r: r - 1, c: c, rows: rows, cols: cols, safeMatrix: &safeMatrix)
        recursiveCheck(r: r, c: c + 1, rows: rows, cols: cols, safeMatrix: &safeMatrix)
        recursiveCheck(r: r, c: c - 1, rows: rows, cols: cols, safeMatrix: &safeMatrix)
        
    }
    
    func getNode(r: Int, c: Int) -> WoolChunkController{
        return woolNodesMatrix[r][c]!
    }
    
    /// Refreshes sheep to original white wool.
    func redo() {
        for y in 0...woolLocations.count-1{
            for x in 0...woolLocations[y].count-1{
                woolNodesMatrix[y][x]?.queueFree()
            }
        }
        placeSheepWool(mode: "redo")
    }
    
    /// Sets mode to coloring wool with specified color.
    func setColorMode(color: Color) {
        selectedFunction = .color
        selectedColor = color
    }
    
    /// Sets mode to shaving wool.
    func setShaveMode() {
        selectedFunction = .shave
    }
    
    /// Sets mode to neither coloring or shaving and updates cursor.
    func setNormalMode() {
        selectedFunction = .normal
        if let tex = GD.load(path: "res://assets/cursor.png") as? Texture2D {
            Input.setCustomMouseCursor(
                image: tex,
                shape: .arrow,
                hotspot: Vector2(x: 0, y: 0)
            )
        }
    }
    
    func getMatrix() -> [[WoolChunkController?]] {
        return woolNodesMatrix
    }
}
