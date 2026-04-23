//
//  shaveFunction.swift
//  Sheep
//
//  Created by Livian on 4/6/26.
//
import SwiftGodot

@Godot
class ShaveFunction : Button {
    
//    func chooseShave() {
//        guard let woolController = getNode(path: NodePath("/root/SceneBarn/WoolController")) as? WoolController else {
//            GD.print("Could not find WoolController")
//            return
//        }
//            
//            woolController.setShaveMode()
//            
//            guard let panel = getNode(path: NodePath("/root/SceneBarn/colorPanel")) as? SidebarPanel else {
//                GD.print("Could not find colorPanel")
//                return
//            }
//            
//            panel.panelDisappear()
//    }
    func chooseShave() {
        guard let woolController = getNode(path: NodePath("/root/SceneBarn/WoolController")) as? WoolController else {
            GD.print("Could not find WoolController")
            return
        }

        woolController.setShaveMode()

        if let tex = GD.load(path: "res://assets/shaver.png") as? Texture2D {
            Input.setCustomMouseCursor(
                image: tex,
                shape: .arrow,
                hotspot: Vector2(x: 0, y: 0)
            )
        }
    }
    
    override func _ready() {
        let pos = self.getPosition()
        self.setPosition(pos)
        
        let originalScale = self.scale
        //self.pivotOffset = self.getSize()/2
            
        focusEntered.connect {
            self.scale = Vector2(x: originalScale.x * 1.1, y: originalScale.y * 1.1)
        }
        
        focusExited.connect {
            self.scale = originalScale
        }
        
        self.pressed.connect {
            self.grabFocus()
            self.chooseShave()
        }
        
    }
}
