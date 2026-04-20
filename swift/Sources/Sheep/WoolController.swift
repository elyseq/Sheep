//
//  WoolController.swift
//  Sheep
//
//  Created by Nora Betry on 3/11/26.
//
//
//  PlayerController.swift
//  Sheep
//
//  Created by Elyse Q on 3/10/26.
//

import SwiftGodot
import Foundation

@Godot
class WoolController: CharacterBody2D {
    var woolLocations: [[String]] = []
    var woolNodesMatrix : [[WoolChunkController?]] = []
    var selectedFunction : String = ""
    var selectedColor: Color = Color(r: 0.0, g: 0.0, b: 0.0, a: 0.0)
    
    var sheepbody = Sprite2D()
    
    var animatedSprite: AnimatedSprite2D?
    var isDragging: Bool = false
    var animationCooldown: Double = 0.0 // wait time
    
    override func _ready() {
        // Sheep Body
        sheepbody = Sprite2D()
        sheepbody.texture = GD.load(path: "res://assets/sheepBody.png") as? Texture2D
        sheepbody.position = Vector2(x: 1100, y: 700)
        sheepbody.scale = Vector2(x: 2, y: 2)
        sheepbody.zIndex = 1
        addChild(node:sheepbody)
        
        // Wool
        self.woolLocations = readFile(fileName: "sheepmatrix.txt")
        for y in 0...woolLocations.count-1{
            woolNodesMatrix.append(Array(repeating: nil, count: woolLocations[y].count))
            let ypos = 7 * y - 100
            for x in 0...woolLocations[y].count-1{
                let xpos = 10 * x - 195
                if(woolLocations[y][x] == "1" || woolLocations[y][x] == "2"){
                    let woolWrapper = WoolThing()
                    //let wool = makeWoolNode(Vector2(x: Float(xpos), y: Float(ypos)))
                    woolWrapper.position = Vector2(x: Float(xpos), y: Float(ypos))
                    woolWrapper.rotation = Double.random(in: 0.0...360.0)
                    woolWrapper.zIndex = 200-abs(Int32(woolWrapper.position.distanceTo(Vector2(x: -70, y: -20))))
                    let wool = woolWrapper.getChunk()
                    
                    //let blackwool = wool.duplicate() as! WoolThing
//                    blackwool.scale = Vector2(x: 1.25, y: 1.25)
//                    blackwool.modulate = Color(r: 0.0, g: 0.0, b: 0.0) // makes these ones black
//                    blackwool.zIndex = -1
//                    
//                    if let blackController = blackwool.getChild(idx: 0) as? WoolChunkController {
//                        blackController.inputPickable = false
//                    }
//
                    
                
                    woolNodesMatrix[y][x] = wool as? WoolChunkController
                    sheepbody.addChild(node: woolWrapper)
                }
                
            }
            
        }
        
        // Sheep Head
        guard let frames = GD.load(path: "res://sheep_animations.tres") as? SpriteFrames else {
            GD.print("Failed to load sprite frames")
            return
        }
        animatedSprite = AnimatedSprite2D()
        animatedSprite?.position = Vector2(x: 785, y: 505)
        animatedSprite?.scale = Vector2(x: 0.525, y: 0.525)
        
        let sheephead = Sprite2D()
        sheephead.texture = GD.load(path: "res://assets/head.png") as? Texture2D
        sheephead.position = Vector2(x: 785, y: 505)
        sheephead.scale = Vector2(x: 0.525, y: 0.525)
        sheephead.zIndex = 250
        addChild(node:sheephead)
        
        animatedSprite?.spriteFrames = frames
        animatedSprite?.zIndex = 250
        addChild(node: animatedSprite!)
    }
    
    override func _process(delta: Double) {
        if isDragging {
            animationCooldown -= delta
            
            if animationCooldown <= 0 {
                triggerRandomAnimation()
                animationCooldown = Double.random(in: 0.75...1.75)
            }
        }
    }
    
    override func _input(event: InputEvent) {
        if event is InputEventMouseMotion && Input.isMouseButtonPressed(button: .left) {
            isDragging = true
        } else if event is InputEventMouseButton {
            let mouseEvent = event as! InputEventMouseButton
            if !mouseEvent.pressed {
                isDragging = false
            }
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
        animatedSprite?.play(name: "blink")
        //GD.print("blink")
    }

    func playEarTwitch() {
        animatedSprite?.play(name: "twitch")
        //GD.print("twitch")
    }
    
    func makeWoolNode (_ pos: Vector2) -> WoolChunkController {
        let n = WoolThing()
        n.position = pos
        n.rotation = Double.random(in:0.0...360.0)
        return n.getChunk()
    }
    
    func readFile(fileName: String) -> [[String]] {
        let path = "res://assets/\(fileName)"
        guard let file = FileAccess.open(path: path, flags: .read) else {
            print("Could not open file at \(path)")
            return []
        }
        
        let content = file.getAsText()
        return content.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map { $0.components(separatedBy: ",") }
    }
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
        
        for r in 0..<rows {
            for c in 0..<cols {
                if woolLocations[r][c] == "2" && !safeMatrix[r][c] {
                    GD.print("in first loop")
                    
                    woolLocations[r][c] = "0"
                    GD.print("Done")
                 //   remove the actual node from the scene
                    GD.print(woolNodesMatrix[r][c])
                    if let node = woolNodesMatrix[r][c] {
                        GD.print("trying to queue free")
                        let tween = createTween()
//                        var xMovement:Float = Float(Bool.random() ? Double.random(in: -110 ... -90) : Double.random(in: 90 ... 110))
//                        tween?.tweenProperty(object: node, property: "global_position", finalVal: Variant(Vector2(x: node.globalPosition.x + xMovement, y: node.globalPosition.y-60)), duration: 0.18)
                        tween?.tweenProperty(object: node.getSprite(), property: "scale", finalVal: Variant(Vector2(x: 0.14,y: 0.15)), duration: 0.1)
                        tween?.tweenProperty(object: node, property: "rotation", finalVal: Variant(Bool.random() ? node.rotation+3*3.14 : node.rotation-3*3.14), duration: 0.5)
//                        tween?.tweenProperty(object: node, property: "global_position", finalVal: Variant(Vector2(x: node.globalPosition.x + xMovement , y: node.globalPosition.y+300)), duration: 0.5)
                        tween?.parallel()?.tweenProperty(object: node.shadowSprite, property: "modulate", finalVal: Variant(Color(r: 1, g: 1, b: 1, a: 0)), duration: 0.1 )
                        tween?.parallel()?.tweenProperty(object: node, property: "modulate", finalVal: Variant(Color(r: 1, g: 1, b: 1, a: 0)), duration: Double.random(in: 0.5 ... 1.0) )
                        tween?.parallel()?.tweenProperty(object: node, property: "scale", finalVal: Variant(Vector2(x: 0.5,y: 0.5)), duration: 0.3)

                    }
                    woolNodesMatrix[r][c] = nil
                    // woolNodesMatrix[r][c] = nil
                }
            }
        }
    }
    
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
    
    func applyColorToWool(_ color: Color) {
        for row in woolNodesMatrix {
            for wool in row {
                wool?.getSprite()?.modulate = color
            }
        }
    }
    
    func redo(){
        self.woolLocations = readFile(fileName: "sheepmatrix.txt")
        for y in 0...woolLocations.count-1{
            woolNodesMatrix.append(Array(repeating: nil, count: woolLocations[y].count))
            let ypos = 7 * y - 100
            for x in 0...woolLocations[y].count-1{
                let xpos = 10 * x - 195
                if(woolLocations[y][x] == "1" || woolLocations[y][x] == "2"){
                    let woolWrapper = WoolThing()
                    //let wool = makeWoolNode(Vector2(x: Float(xpos), y: Float(ypos)))
                    woolWrapper.position = Vector2(x: Float(xpos), y: Float(ypos))
                    woolWrapper.rotation = Double.random(in: 0.0...360.0)
                    woolWrapper.zIndex = 200-abs(Int32(woolWrapper.position.distanceTo(Vector2(x: -70, y: -20))))
                    let wool = woolWrapper.getChunk()
                    
                    //let blackwool = wool.duplicate() as! WoolThing
//                    blackwool.scale = Vector2(x: 1.25, y: 1.25)
//                    blackwool.modulate = Color(r: 0.0, g: 0.0, b: 0.0) // makes these ones black
//                    blackwool.zIndex = -1
//
//                    if let blackController = blackwool.getChild(idx: 0) as? WoolChunkController {
//                        blackController.inputPickable = false
//                    }
//
                    
                
                    woolNodesMatrix[y][x] = wool as? WoolChunkController
                    sheepbody.addChild(node: woolWrapper)
                }
                
            }
            
        }
    }
    
    func setColorMode(color: Color) {
        selectedFunction = "color"
        selectedColor = color
    }
    
    func setShaveMode() {
        selectedFunction = "shave"
    }
    
    func getMatrix() -> [[WoolChunkController?]] {
        return woolNodesMatrix
    }
}
