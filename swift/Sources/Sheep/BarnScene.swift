//
//  BarnScene.swift
//  Sheep
//
//  Created by Maddy Scott on 4/5/26.
//
import SwiftGodot

@Godot
class SceneBarn: Node2D {
    var woolController: WoolController!

    override func _ready() {
        woolController = getNode(path: "WoolController") as? WoolController

        let ui = ColorButton()
        ui.woolController = woolController
        addChild(node: ui)
    }
}
