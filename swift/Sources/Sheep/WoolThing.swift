//
//  WoolThing.swift
//  Sheep
//
//  Created by Maddy Scott on 3/31/26.
//
import SwiftGodot

@Godot
class WoolThing: CharacterBody2D {
    
    var chunk: WoolChunkController!
    
    override func _ready () {
        chunk = WoolChunkController()
        self.addChild(node: chunk)
        self.inputPickable = true
    }
    
    func setColor(_ color: Color) {
        chunk.modulate = color
    }
}
