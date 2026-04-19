//
//  ColorButton.swift
//  Sheep
//
//  Created by Elyse Q on 4/2/26.
//
import SwiftGodot

@Godot
class ColorChanger: Control {
    
    var woolController: WoolController?
    
    override func _ready() {
        GD.print("ColorButton ready")
        
        let pickerButton = ColorPickerButton()
        pickerButton.text = "Pick Wool Color"
        pickerButton.editAlpha = true
        
        pickerButton.colorChanged.connect { newColor in
            self.onColorChanged(newColor)
            GD.print("color changed")
        }
        
        addChild(node: pickerButton)
    }
    
    func onColorChanged(_ color: Color) {
        woolController?.applyColorToWool(color)
        GD.print("tried to apply color")
    }
}
