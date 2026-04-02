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
            self.getTree()?.changeSceneToFile(path: "res://main.tscn")
        }
    }
}
