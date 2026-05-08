///
///  WoolThing.swift
///  Sheep
///
///  Created by Maddy Scott on 3/31/26.
///  
///  Modulates color for each wool piece and it's shadow.

import SwiftGodot

@Godot
class WoolThing: CharacterBody2D {
    
    var chunk: WoolChunkController = WoolChunkController()
    
    override func _ready () {
        self.addChild(node: chunk)
        self.inputPickable = true
    }
    
    /// Sets painting color.
    func setColor(_ color: Color) {
        chunk.modulate = color
    }
    
    func getSprite() -> Sprite2D? {
        return(chunk.getSprite())
    }
    
    func getChunk() -> WoolChunkController {
        return(self.chunk)
    }
    
    func getColor() -> Color {
        return chunk.getColor()
    }
}
