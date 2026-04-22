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
            if let woolController = self.getNode(path: NodePath("/root/SceneBarn/WoolController")
                ) as? WoolController {
                        woolController.setNormalMode()
                    }
            self.getTree()?.changeSceneToFile(path: "res://main.tscn")
        
        }
    }
}
