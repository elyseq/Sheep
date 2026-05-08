//
//  sceneSwitch.swift
//  Sheep
//
//  Created by Livian on 3/30/26.
import SwiftGodot

@Godot
final class MainToBarnSceneSwitch : Button {
//switch scene from the main scene to the barn scene
    override func _ready() {
        self.pressed.connect {
            self.getTree()?.changeSceneToFile(path: "res://scene_barn.tscn")
            
        }
    }
}


