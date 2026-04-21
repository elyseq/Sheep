//
//  SelectionBox.swift
//  Sheep
//
//  Created by Maddy Scott on 4/21/26.
//
import SwiftGodot

@Godot
class SelectionBox : Panel {
    
    var currentButton: Control?

    override func _ready() {
        self.visible = false
        let style = createStyle()
        self.addThemeStyleboxOverride(name: "panel", stylebox: style)
    }
    
    func createStyle() -> StyleBoxFlat {
        let style = StyleBoxFlat()
        //style.borderWidthAll = 3
        style.borderColor = Color(r: 1, g: 1, b: 1, a: 1)
        style.bgColor = Color(r: 0, g: 0, b: 0, a: 0)
        return style
    }

    func select(button: Control) {
        currentButton = button
        self.visible = true
        
        let rect = button.getGlobalRect()
        
        self.setGlobalPosition(rect.position)
        self.setSize(rect.size)
    }

    func clearSelection() {
        currentButton = nil
        self.visible = false
    }
}
