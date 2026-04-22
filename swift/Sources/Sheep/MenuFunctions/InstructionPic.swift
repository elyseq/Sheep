//
//  InstructionPic.swift
//  Sheep
//
//  Created by Livian on 4/22/26.
//
import SwiftGodot

@Godot
class InstructionPic : Sprite2D {
    func InstructionAppear () {
        self.visible = true
    }
    
    func InstructionDisappear () {
        self.visible = false
    }
}
