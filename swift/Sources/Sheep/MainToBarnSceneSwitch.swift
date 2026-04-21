//
//  sceneSwitch.swift
//  Sheep
//
//  Created by Livian on 3/30/26.
import SwiftGodot

@Godot
final class MainToBarnSceneSwitch : Button {
    override func _ready() {
        Input.setCustomMouseCursor(image: nil)
        self.pressed.connect {
            self.getTree()?.changeSceneToFile(path: "res://scene_barn.tscn")
        }
    }
}


