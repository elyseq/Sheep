// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftGodot

#initSwiftExtension(cdecl: "swift_entry_point", types: [WoolController.self, WoolThing.self, WoolChunkController.self, Player.self, sceneSwitch.self])

func makeWoolNode(_ pos: Vector2) -> Node {
    let n = WoolThing()
    n.position = pos
    n.rotation = Double.random(in:0.0...360.0)
    return n
}



@Godot
class WoolThing: CharacterBody2D {
    
    override func _ready () {
        let chunk = WoolChunkController()
        self.addChild(node: chunk)
        self.inputPickable = true
        
   

    }
    
        
}
