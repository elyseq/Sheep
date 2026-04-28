//
//  colorFunction.swift
//  Sheep
//
//  Created by Livian on 4/6/26.
//
import SwiftGodot

@Godot
class ColorFunction : Button {
    @Export var colorName : String = ""

    func chooseColor() {
         guard let woolController = getNode(path: NodePath("/root/SceneBarn/WoolController")) as? WoolController else {
             GD.print("Could not find WoolController")
             return
         }
        
//        guard let panel = getNode(path: NodePath("/root/SceneBarn/colorPanel")) as? SidebarPanel else {
//            GD.print("Could not find colorPanel")
//            return
//        }
//        
//        panel.panelAppear()

         if colorName == "red" {
             woolController.setColorMode(color: Color(r: 1.0, g: 0.5451, b: 0.5765, a: 0.8))
         } else if colorName == "orange" {
             woolController.setColorMode(color: Color(r: 1.0, g: 0.733, b: 0.729, a: 0.8))
         } else if colorName == "yellow" {
             woolController.setColorMode(color: Color(r: 0.996, g: 1.0, b: 0.549, a: 0.8))
         } else if colorName == "green" {
             woolController.setColorMode(color: Color(r: 0.7176, g: 1.0, b: 0.7412, a: 0.8))
         } else if colorName == "blue" {
             woolController.setColorMode(color: Color(r: 0.48, g: 0.835, b: 1.0, a: 0.8))
         } else if colorName == "purple" {
             woolController.setColorMode(color: Color(r: 0.6078, g: 0.6, b: 1, a: 0.8))
         } else if colorName == "pink" {
             woolController.setColorMode(color: Color(r: 0.9843, g: 0.8039, b: 0.949, a: 0.8))
         } else {
             woolController.setColorMode(color: Color(r: 0.965, g: 0.945, b: 0.898))
         }
     }
    
    override func _ready() {
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
            self.chooseColor()
        }
    }
}
