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
            
            if let woolController = self.getNode(path: NodePath("/root/SceneBarn/WoolController")) as? WoolController {
                woolController.setNormalMode()
            }
            self.getTree()?.changeSceneToFile(path: "res://main.tscn")
        
        }
    }
}
