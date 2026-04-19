// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftGodot

#initSwiftExtension(cdecl: "swift_entry_point", types: [
    WoolController.self,
    WoolThing.self,
    WoolChunkController.self,
    MainToBarnSceneSwitch.self,
    penSceneSwitch.self,
    WalkingSheep.self,
    WalkingSheepSpawner.self,
    ColorChanger.self,
    ColorFunction.self,
    ShaveFunction.self,
    SidebarButton.self,
    SidebarPanel.self,
    BrushSize.self,
])

@Godot
class MainScene: Node2D {

    override func _ready() {
        let bg = Sprite2D()
        let texture = GD.load(path: "res://background.jpg") as! Texture2D
        bg.texture = texture
        bg.position = Vector2(x: 400, y: 300)
        addChild(node: bg)

        WalkingSheepSpawner()
    }
}
