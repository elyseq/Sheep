//
//  SelectionManager.swift
//  Sheep
//
//  Created by Maddy Scott on 4/21/26.
//
import SwiftGodot

@Godot
class SelectionManager : Node {
    
    var selectionBox: SelectionBox?
    var current: Control?

    override func _ready() {
        //selectionBox = getNode(path: NodePath("/root/SceneBarn/SelectionBox")) as? SelectionBox
        
        guard let box = getNode(path: NodePath("/root/SceneBarn/SelectionBox")) as? SelectionBox else {
            GD.print("Could not find SelectionBox")
            return
        }
        self.selectionBox = box
    }

    func select(button: Control) {
        if current == button { return }

        current = button
        selectionBox?.select(button: button)
    }

    func clear() {
        current = nil
        selectionBox?.clearSelection()
    }
}
