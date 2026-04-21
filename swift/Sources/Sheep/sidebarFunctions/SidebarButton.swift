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
            self.selectFunction()
        }
            self.selectThis()
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
    func selectFunction() {
           guard let woolController = getNode(path: NodePath("/root/SceneBarn/WoolController")) as? WoolController else {
               GD.print("Could not find WoolController")
               return
           }

           if functionName == "color" {
               woolController.setColorMode(color: Color(r: 1.0, g: 1.0, b: 1.0, a: 1.0))
              
               if let tex = GD.load(path: "res://assets/paint_brush.png") as? Texture2D {
                       Input.setCustomMouseCursor(
                           image: tex,
                           shape: .arrow,
                           hotspot: Vector2(x: 0, y: 25)
                       )
                           }
               GD.print("SET CURSOR")
           } else if functionName == "shave" {
               woolController.setShaveMode()
           }
       }
    
    func selectThis() {
        if let manager = getNode(path: NodePath("/root/SceneBarn/SelectionManager")) as? SelectionManager {
            manager.select(button: self)
        }
    }
    
}
