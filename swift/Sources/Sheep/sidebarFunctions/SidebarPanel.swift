//
//  sidebarPanel.swift
//  Sheep
//
//  Created by Livian on 4/2/26.
//
import SwiftGodot

@Godot
class SidebarPanel : Panel {
    
    func panelAppear () {
        self.visible = true
    }
    
    func panelDisappear () {
        self.visible = false
    }
}
