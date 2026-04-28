//
//  InstructionButton.swift
//  Sheep
//
//  Created by Livian on 4/22/26.
//

import SwiftGodot

@Godot
class InstructionButton : Button {
// if click the instruction button, the instruction would show up
    var PicSelected: InstructionPic?
    var clickTime = 0
    
    override func _ready() {

        PicSelected = getNode(path: NodePath("/root/PenScene/MenuPanel/instructions/InstructionNote")) as? InstructionPic

        self.pressed.connect {
            self.NoteVisibility()
        }
            
            
    }

    func NoteVisibility() {
    // check if the instruction pic is visable or not when the button is clicked; if visable, make it disappear
        guard let panel = PicSelected else { return }
        
        if panel.visible {
            panel.InstructionDisappear()
        } else {
            panel.InstructionAppear()
        }
    }
}
