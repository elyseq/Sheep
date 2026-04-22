//
//  MenuButtonMy.swift
//  Sheep
//
//  Created by Livian on 4/21/26.
//

import SwiftGodot

@Godot
class MenuButtonMy : Button {
    var panelSelected: MenuPanel?
    var clickTime = 0
    
    override func _ready(){

        panelSelected = getNode(path: NodePath("/root/PenScene/MenuPanel")) as? MenuPanel

        self.pressed.connect{
            self.panelVisibility()
        }
            
            
    }

    func panelVisibility() {
        guard let panel = panelSelected else { return }
        
        if panel.visible {
            panel.panelDisappear()
        } else {
            panel.panelAppear()
        }
    }
}
