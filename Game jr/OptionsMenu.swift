//
//  options.swift
//  Game jr.
//
//  Created by WALLS BENAJMIN A on 4/11/16.
//  Copyright © 2016 WALLS BENAJMIN A. All rights reserved.
//

import Foundation
import SpriteKit

class OptionsMenu : SKScene {
    
    var backButton : SKLabelNode?
    
    override func didMoveToView(view: SKView) {
        backButton = self.childNodeWithName("SKLbackToMain") as! SKLabelNode!
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            print("X:\(location.x) Y:\(location.y)")
            print(nodeAtPoint(location).name)
            
            
            if nodeAtPoint(location).name == backButton!.name {
                print("back button clicked")
                //load options scene
                let mainScene = MainMenu(fileNamed: "MainMenu")
                
                mainScene?.scaleMode = .AspectFill
                self.view?.presentScene(mainScene!, transition: SKTransition.doorsCloseHorizontalWithDuration(0.9))
            }
            
        }
    }

    
    
}