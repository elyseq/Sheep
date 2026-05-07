//
//  redoButton.swift
//  Sheep
//
//  Created by Maddy Scott on 4/19/26.
//
import SwiftGodot

@Godot
final class redoButton : Button {
    @Export var sliderPath: NodePath = NodePath()

    //redo everything you have made to the sheep
    override func _ready() {
        self.pressed.connect { [self] in
 
            if let woolControl = self.getNode(path: "/root/SceneBarn/WoolController") as? WoolController {
                woolControl.redo()
            } else {
                print("WoolController not found")
            }
            if let slider = getNode(path: sliderPath) as? HSlider {
                slider.value += Double(-1) * 5
                slider.value += Double(1) * 5
            } else {
                return
            }
        }
    }
}
