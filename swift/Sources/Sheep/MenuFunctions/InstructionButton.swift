//
//  InstructionButton.swift
//  Sheep
//
//  Created by Livian on 4/22/26.
//

import SwiftGodot

@Godot
class InstructionButton : Button {
    var PicSelected: InstructionPic?
    var clickTime = 0
    
    override func _ready(){

        PicSelected = getNode(path: NodePath("/root/PenScene/MenuPanel/instructions/InstructionNote")) as? InstructionPic

        self.pressed.connect{
            self.NoteVisibility()
        }
            
            
    }

    func NoteVisibility() {
        guard let panel = PicSelected else { return }
        
        if panel.visible {
            panel.InstructionDisappear()
        } else {
            panel.InstructionAppear()
        }
    }
}
