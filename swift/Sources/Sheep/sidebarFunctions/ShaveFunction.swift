//
//  shaveFunction.swift
//  Sheep
//
//  Created by Livian on 4/6/26.
//
import SwiftGodot

@Godot
class ShaveFunction : Button {
    
    func chooseShave() {
        guard let woolController = getNode(path: NodePath("/root/SceneBarn/WoolController")) as? WoolController else {
            GD.print("Could not find WoolController")
            return
        }
            
            woolController.setShaveMode()
            
            guard let panel = getNode(path: NodePath("/root/SceneBarn/colorPanel")) as? SidebarPanel else {
                GD.print("Could not find colorPanel")
                return
            }
            
            panel.panelDisappear()
    }
    
    override func _ready() {
        self.pressed.connect {
            self.chooseShave()
        }
        
    }
}
