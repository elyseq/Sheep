//
//  SizeButton.swift
//  Sheep
//
//  Created by Nora Betry on 4/21/26.
//

import SwiftGodot

@Godot
class SizeButton: Button {
    //adjust the size by clicking the button 
    @Export var sliderPath: NodePath = NodePath()
    @Export var direction = Int()
    
    override func _ready(){
        self.pressed.connect {
            self.moveInDirection()
        }
    }
    
    func moveInDirection(){
        if let slider = getNode(path: sliderPath) as? HSlider {
            slider.value += Double(direction) * 5
        } else {
            return
        }
    }
}
