//
//  FunctionButtonClass.swift
//  Sheep
//
//  Created by Livian on 4/2/26.
//
import SwiftGodot

@Godot
class SidebarButton : Button {
    @Export var functionName: String = ""
    var panelSelected: SidebarPanel?
    var clickTime = 0
    

    override func _ready(){
        
        let panelName = functionName + "Panel"
        let pathName = "/root/SceneBarn/" + panelName

        panelSelected = getNode(path: NodePath(pathName)) as? SidebarPanel

        self.pressed.connect{
            self.panelVisibility()
            }
    }

    func panelVisibility() {
//        check the visibility of the panel, if visible--click--become incisible.
        guard let panel = panelSelected else { return }
        
        if panel.visible {
            panel.panelDisappear()
        } else {
            panel.panelAppear()
        }
    }
    
}
