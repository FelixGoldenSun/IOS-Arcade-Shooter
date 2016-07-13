//
//  MainMenu.swift
//  Game jr.
//
//  Created by WALLS BENAJMIN A on 4/6/16.
//  Copyright © 2016 WALLS BENAJMIN A. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu : SKScene {
    
    var playButton : SKLabelNode?
    var optionsButton : SKLabelNode?
    
    override func didMoveToView(view: SKView) {
        playButton = self.childNodeWithName("SKLabelNode_0") as! SKLabelNode!
        optionsButton = self.childNodeWithName("SKLabelNode_1") as! SKLabelNode!
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            print("X:\(location.x) Y:\(location.y)")
            print(nodeAtPoint(location).name)
            
            if nodeAtPoint(location).name == playButton!.name {
                print("Play clicked")
                //load game scene
                let gameScene = GameScene(fileNamed: "GameScene")
                
                gameScene?.scaleMode = .AspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.doorsOpenHorizontalWithDuration(0.9))

            }
            
            if nodeAtPoint(location).name == optionsButton!.name {
                print("options clicked")
                //load options scene
                let optionsScene = OptionsMenu(fileNamed: "OptionsMenu")
                
                optionsScene?.scaleMode = .AspectFill
                self.view?.presentScene(optionsScene!, transition: SKTransition.doorsOpenHorizontalWithDuration(0.9))
            }

        }
    }

    
}