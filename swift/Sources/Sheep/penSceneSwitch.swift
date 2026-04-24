//
//  penSceneSwitch.swift
//  Sheep
//
//  Created by Elyse Q on 4/2/26.
//

import SwiftGodot

@Godot
final class penSceneSwitch : Button {
    
    override func _ready() {

        self.pressed.connect {
            guard let root = self.getTree()?.currentScene else {
                GD.print("No current scene")
                return
            }
            
            guard let woolController = root.getNode(path: "WoolController") as? WoolController else {
                GD.print("No wool controller found to save")
                self.getTree()?.changeSceneToFile(path: "res://main.tscn")
                return
            }

            SavedSheep.shared.save(from: woolController)
            
            if let woolController = self.getNode(path: NodePath("/root/SceneBarn/WoolController")) as? WoolController { //wasn't here before
                woolController.setNormalMode()
            } //wasn't here before
            self.getTree()?.changeSceneToFile(path: "res://main.tscn")
            
            if let tex = GD.load(path: "res://assets/cursor.png") as? Texture2D {
                Input.setCustomMouseCursor(
                    image: tex,
                    shape: .arrow,
                    hotspot: Vector2(x: 0, y: 0)
                )
                        }
            GD.print("SET CURSOR")
        
        }
    }
}
