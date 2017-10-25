//
//  scoreBoardscene.swift
//  Bug Game
//
//  Created by Jonas Haag on 2017-10-13.
//  Copyright © 2017 Jonas Haag. All rights reserved.
//

import SpriteKit

class scoreBoardScene: SKScene
{
   
    
    override func didMove(to view: SKView)
    {
        scoreboard()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func scoreboard()
    {
        let label =  SKLabelNode(text: "Start Game")
        
        label.position = CGPoint(x: 0, y: 0)
        label.fontSize = 45
        label.fontColor = SKColor.black
        label.fontName = "Avenir"
        
        self.addChild(label)
    }
}

