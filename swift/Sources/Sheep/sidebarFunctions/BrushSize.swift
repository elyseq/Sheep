//
//  BrushSize.swift
//  Sheep
//
//  Created by Nora Betry on 4/17/26.
//
import SwiftGodot

@Godot
class BrushSize : HSlider {
    var woolController = WoolController()
    override func _ready() {
        
        self.valueChanged.connect(self.change_brush_size)
        
    }
    
    func change_brush_size(value: Double) {
        self.woolController = getNode(path: NodePath("/root/SceneBarn/WoolController")) as! WoolController
        let chunkMatrix = woolController.getMatrix()
        let rows = chunkMatrix.count
        let cols = chunkMatrix[0].count
        for r in 0..<rows-1 {
            for c in 0..<cols-1 {
                chunkMatrix[r][c]?.changeCollisionSize(value: value)
            }
        }
    }
}

