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
             woolController.setColorMode(color: Color(r: 1.0, g: 0.0, b: 0.0, a: 0.8))
         } else if colorName == "orange" {
             woolController.setColorMode(color: Color(r: 1.0, g: 0.5, b: 0.0, a: 0.8))
         } else if colorName == "yellow" {
             woolController.setColorMode(color: Color(r: 1.0, g: 1.0, b: 0.0, a: 0.8))
         } else if colorName == "green" {
             woolController.setColorMode(color: Color(r: 0.0, g: 1.0, b: 0.0, a: 0.8))
         } else if colorName == "blue" {
             woolController.setColorMode(color: Color(r: 0.0, g: 0.0, b: 1.0, a: 0.8))
         } else if colorName == "purple" {
             woolController.setColorMode(color: Color(r: 0.5, g: 0.0, b: 0.6, a: 0.8))
         } else if colorName == "pink" {
             woolController.setColorMode(color: Color(r: 1.0, g: 0.5, b: 1.0, a: 0.8))
         } else {
             woolController.setColorMode(color: Color(r: 1.0, g: 1.0, b: 1.0, a: 0.8))
         }
     }
    
    override func _ready() {
        self.pressed.connect {
            self.chooseColor()
        }
    }
}
