//
//  WoolThing.swift
//  Sheep
//
//  Created by Maddy Scott on 3/31/26.
//
import SwiftGodot

@Godot
class WoolThing: CharacterBody2D {
    
    override func _ready () {
        let chunk = WoolChunkController()
        self.addChild(node: chunk)
        self.inputPickable = true
    }
}
