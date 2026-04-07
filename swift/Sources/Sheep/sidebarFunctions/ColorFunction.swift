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

    override func _ready() {
        self.pressed.connect {
            self.chooseColor()
        }
    }
    
    
    func chooseColor() {
         guard let woolController = getNode(path: NodePath("/root/SceneBarn/WoolController")) as? WoolController else {
             GD.print("Could not find WoolController")
             return
         }

         if colorName == "red" {
             woolController.setColorMode(color: Color(r: 1.0, g: 0.0, b: 0.0, a: 1.0))
         } else if colorName == "blue" {
             woolController.setColorMode(color: Color(r: 0.0, g: 0.0, b: 1.0, a: 1.0))
         } else if colorName == "green" {
             woolController.setColorMode(color: Color(r: 0.0, g: 1.0, b: 0.0, a: 1.0))
         }
     }
}
