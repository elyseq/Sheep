//
//  InstructionPanel.swift
//  Sheep
//
//  Created by Livian on 4/30/26.
//

import SwiftGodot

@Godot
class InstructionPanel : Panel {
//hold the instructions and the button to turn off the panel
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
        
//        have the animation of twinkling of the button
        guard let tween = createTween() else {
            GD.print("Could not create tween")
            return
        }
        tween.setLoops()
        tween.tweenProperty(object: turnOffButton, property: "scale", finalVal: Variant(Vector2( x: 1.2, y: 1.2)), duration: 0.3)
        tween.tweenProperty(object: turnOffButton, property: "scale", finalVal: Variant(Vector2( x: 1, y: 1)), duration: 0.3)
        tween.tweenProperty(object: turnOffButton, property: "scale", finalVal: Variant(Vector2( x: 1, y: 1)), duration: 0.9)

        turnOffButton.pressed.connect {
            self.closeInstruction()
        }
    }

    func closeInstruction() {
        self.visible = false
        InstructionPanel.hasClosedInstruction = true
    }
}
