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
        self.pressed.connect {
            self.chooseShave()
        }
        
    }
}
