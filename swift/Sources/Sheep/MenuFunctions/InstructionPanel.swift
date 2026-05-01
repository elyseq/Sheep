//
//  InstructionPanel.swift
//  Sheep
//
//  Created by Livian on 4/30/26.
//

import SwiftGodot

@Godot
class InstructionPanel : Panel {
    nonisolated(unsafe) static var hasClosedInstruction: Bool = false

    override func _ready() {
        if InstructionPanel.hasClosedInstruction {
            self.visible = false
        } else {
            self.visible = true
        }

        guard let turnOffButton = getNode(path: NodePath("closeInstructionButton")) as? Button else {
            GD.print("Could not find closeInstructionButton")
            return
        }

        turnOffButton.pressed.connect {
            self.closeInstruction()
        }
    }

    func closeInstruction() {
        self.visible = false
        InstructionPanel.hasClosedInstruction = true
    }
}
