//
//  MenuPanel.swift
//  Sheep
//
//  Created by Livian on 4/21/26.
//
import SwiftGodot

@Godot

class MenuPanel: Panel {
    
    func panelAppear () {
        self.visible = true
    }
    
    func panelDisappear () {
        self.visible = false
    }
}
