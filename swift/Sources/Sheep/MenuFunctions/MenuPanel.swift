//
//  MenuPanel.swift
//  Sheep
//
//  Created by Livian on 4/21/26.
//
import SwiftGodot

@Godot

class MenuPanel: Panel {
//set the visibility of the menu panel
    func panelAppear () {
        self.visible = true
    }
    
    func panelDisappear () {
        self.visible = false
    }
}
