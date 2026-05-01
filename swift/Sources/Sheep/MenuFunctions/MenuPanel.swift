//
//  MenuPanel.swift
//  Sheep
//
//  Created by Livian on 4/21/26.
//
import SwiftGodot

@Godot
class MenuPanel: Panel {

    override func _ready() {
        self.visible = false

        guard let turnOffButton = getNode(path: NodePath("okButton")) as? Button else {
            GD.print("Could not find okButton")
            return
        }

        turnOffButton.pressed.connect {
            self.panelDisappear()
        }
    }

    func panelAppear() {
        self.visible = true
    }

    func panelDisappear() {
        self.visible = false
    }
}
