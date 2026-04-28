//
//  MenuButtonMy.swift
//  Sheep
//
//  Created by Livian on 4/21/26.
//

import SwiftGodot

@Godot
class MenuButtonMy : Button {
//click the menu button and the menu panel would show up
    var panelSelected: MenuPanel?
    var clickTime = 0
    
    override func _ready() {
        panelSelected = getNode(path: NodePath("/root/PenScene/MenuPanel")) as? MenuPanel
            self.pressed.connect {
                self.panelVisibility()
            }
    }

    func panelVisibility() {
        // check if the menu panel is visable or not when the button is clicked; if visable, make it disappear
        guard let panel = panelSelected else { return }
        if panel.visible {
            panel.panelDisappear()
        } else {
            panel.panelAppear()
        }
    }
}
