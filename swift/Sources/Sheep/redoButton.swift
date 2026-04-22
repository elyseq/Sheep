//
//  redoButton.swift
//  Sheep
//
//  Created by Maddy Scott on 4/19/26.
//
import SwiftGodot

@Godot
final class redoButton : Button {
    override func _ready() {
        self.pressed.connect {
            if let woolControl = self.getNode(path: "/root/SceneBarn/WoolController") as? WoolController {
                woolControl.redo()
            } else {
                print("WoolController not found")
            }
        }
    }
}
