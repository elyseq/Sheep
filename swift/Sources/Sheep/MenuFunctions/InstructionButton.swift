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
    var Inspanel: InstructionPanel?
    var clickTime = 0
    
    override func _ready() {

        Inspanel = getNode(path: NodePath("/root/PenScene/InstructionPanel")) as? InstructionPanel

        self.pressed.connect {
            self.NoteVisibility()
        }
            
            
    }

    func NoteVisibility() {
    // check if the instruction pic is visable or not when the button is clicked; if visable, make it disappear
        guard let panel = Inspanel else { return }
        
        if panel.visible == false {
            panel.visible = true
        }
    }
}
