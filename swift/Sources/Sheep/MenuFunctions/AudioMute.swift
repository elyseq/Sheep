//
//  AudioMute.swift
//  Sheep
//
//  Created by Livian on 4/21/26.
//

import SwiftGodot

@Godot
class AudioMute : CheckButton {
// mute the background music, but keep the shaving noize
    var originalVolume: Double = 0.0
    override func _ready() {
           self.toggled.connect {
               checked in
               guard let root = self.getNode(path: NodePath("/root/AudioStreamPlayer2d"))
               else {
                    GD.print("Could find autoload root")
                    return
                      }
               
               guard let musicPlayer = self.getNode(path: NodePath("/root/AudioStreamPlayer2d")) as? AudioStreamPlayer2D
                else {
                   GD.print("Could not find music player")
                   return
               }
               
               if checked {
                    musicPlayer.volumeDb = -80.0
               } else {
                   musicPlayer.volumeDb = self.originalVolume
                }
           }
       }
}
