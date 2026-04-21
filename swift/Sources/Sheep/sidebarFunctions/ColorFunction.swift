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
             woolController.setColorMode(color: Color(r: 1.0, g: 0.6784, b: 0.6784, a: 0.8))
         } else if colorName == "orange" {
             woolController.setColorMode(color: Color(r: 0.9921, g: 0.8549, b: 0.7058, a: 0.8))
         } else if colorName == "yellow" {
             woolController.setColorMode(color: Color(r: 0.9882, g: 0.9568, b: 0.7882, a: 0.8))
         } else if colorName == "green" {
             woolController.setColorMode(color: Color(r: 0.7333, g: 0.9529, b: 0.7529, a: 0.8))
         } else if colorName == "blue" {
             woolController.setColorMode(color: Color(r: 0.7372, g: 0.8471, b: 0.9254, a: 0.8))
         } else if colorName == "purple" {
             woolController.setColorMode(color: Color(r: 0.9098, g: 0.7451, b: 0.9804, a: 0.8))
         } else if colorName == "pink" {
             woolController.setColorMode(color: Color(r: 0.9843, g: 0.8039, b: 0.949, a: 0.8))
         } else {
             woolController.setColorMode(color: Color(r: 1.0, g: 1.0, b: 1.0, a: 0.8))
         }
     }
    
    override func _ready() {
        self.pressed.connect {
            self.chooseColor()
            self.selectThis()
        }
    }
    
    func selectThis() {
        if let manager = getNode(path: NodePath("/root/SceneBarn/SelectionManager")) as? SelectionManager {
            manager.select(button: self)
        }
    }
}
