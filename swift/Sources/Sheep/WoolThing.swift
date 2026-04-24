//
//  WoolThing.swift
//  Sheep
//
//  Created by Maddy Scott on 3/31/26.
//
import SwiftGodot

@Godot
class WoolThing: CharacterBody2D {
    
    var chunk: WoolChunkController = WoolChunkController()
    
    override func _ready () {
        self.addChild(node: chunk)
        self.inputPickable = true
    }
    
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
