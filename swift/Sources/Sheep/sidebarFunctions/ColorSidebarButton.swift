//
//  FunctionButtonClass.swift
//  Sheep
//
//  Created by Livian on 4/2/26.
//
import SwiftGodot

@Godot
class ColorSidebarButton : Button {
    @Export var functionName: String = ""
    var panelSelected: SidebarPanel?
    var clickTime = 0
    
    override func _ready() {
        let panelName = functionName + "Panel"
        let pathName = "/root/SceneBarn/" + panelName
        panelSelected = getNode(path: NodePath(pathName)) as? SidebarPanel
        let overlay = Panel()
        let style = StyleBoxFlat()
        style.bgColor = Color(r: 0, g: 0, b: 0, a: 0)
        style.borderColor = Color(r: 1.0, g: 1.0, b: 1.0, a: 0.8)
        style.setBorderWidthAll(width: 5)
        style.drawCenter = false
        overlay.addThemeStyleboxOverride(name: "panel", stylebox: style)
        focusEntered.connect {
            overlay.visible = true
        }
        focusExited.connect {
            overlay.visible = false
        }
        self.pressed.connect {
            self.grabFocus()
            self.panelVisibility()
            self.selectFunction()
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
        //set the coloring mode and adjust the defaulted color to the wool color, and set the cursor to the paint brush
           guard let woolController = getNode(path: NodePath("/root/SceneBarn/WoolController")) as? WoolController else {
               GD.print("Could not find WoolController")
               return
           }
           if functionName == "color" {
               woolController.setColorMode(color: Color(r: 0.965, g: 0.945, b: 0.898))
               if let tex = GD.load(path: "res://assets/brushCursor.png") as? Texture2D {
                   Input.setCustomMouseCursor(
                       image: tex,
                       shape: .arrow,
                       hotspot: Vector2(x: 0, y: 40)
                   )
                }
                GD.print("SET CURSOR")
           } else if functionName == "shave" {
               woolController.setShaveMode()
           }
       }
}
