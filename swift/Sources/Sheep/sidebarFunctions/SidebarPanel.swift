//
//  sidebarPanel.swift
//  Sheep
//
//  Created by Livian on 4/2/26.
//
import SwiftGodot

@Godot
public class SidebarPanel : Panel {
    //set the visibility
    func panelAppear () {
        self.visible = true
    }
    
    func panelDisappear () {
        self.visible = false
    }
}
