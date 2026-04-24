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

        if let tex = GD.load(path: "res://assets/razorCursor.png") as? Texture2D {
            Input.setCustomMouseCursor(
                image: tex,
                shape: .arrow,
                hotspot: Vector2(x: 0, y: 0)
            )
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
            self.chooseShave()
        }
        
    }
}
