//
//  shaveFunction.swift
//  Sheep
//
//  Created by Livian on 4/6/26.
//
import SwiftGodot

@Godot
class ShaveFunction : Button {
//set the mode into shaving mode when clickingbthe shaving button
    func chooseShave() {
        //reset the cursor and set the shaving mode，color panel dissappear when set into the shaving mode
        guard let woolController = getNode(path: NodePath("/root/SceneBarn/WoolController")) as? WoolController else {
            GD.print("Could not find WoolController")
            return
        }
        
        guard let panel = getNode(path: NodePath("/root/SceneBarn/colorPanel")) as? SidebarPanel else {
                        GD.print("Could not find colorPanel")
                        return
                    }
        
                    panel.panelDisappear()
            

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
        let style = StyleBoxFlat()
        style.bgColor = Color(r: 0, g: 0, b: 0, a: 0)
        style.borderColor = Color(r: 1.0, g: 1.0, b: 1.0, a: 0.8)
        style.setBorderWidthAll(width: 5)
        style.drawCenter = false
        self.pressed.connect {
            self.grabFocus()
            self.chooseShave()
        }
        
    }
}
