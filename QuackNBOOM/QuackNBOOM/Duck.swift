//
//  Duck.swift
//  QuackNBOOM
//
//  Created by Ngo Tuyetnhi N. and Benoit Neriah R. on 3/4/18.
//  Copyright © 2018 Neriah and Neenee. All rights reserved.
//
// Duck inherits from GameObject with added functionality specific to the falling duck.
// There is an array of ducks and each individual duck will be placed above the top of the screen.
// When the duck is destroyed, the duck will be moved back to the initial placement rather than create and destroy all the time
// once the duck reaches the bottom of the screen, the player will lose

import Foundation
import SpriteKit
import AVFoundation

class Duck: GameObject {
    //boolean if duck is dead or not
    var isDead = false //ducks start as 'not dead'
    var gameOver = false
    var startPos = CGPoint(x: 0, y: 0)
    //speed of the duck
    let vel = CGFloat(450) //250
    //the audio components of the duck
    var quackSFX1 = AVAudioPlayer()
    var quackSFX2 = AVAudioPlayer()
    //the file paths of each audio
    let quackSound1 = Bundle.main.path(forResource: "DemonicQuack1", ofType: "wav")
    let quackSound2 = Bundle.main.path(forResource: "DemonicQuack2", ofType: "wav")
    
    // Sets the sprite's image
    required init(imagePath: String){
        super.init(imagePath: imagePath)
        // Proper scale for the ducks
        xScale = 0.75
        yScale = 0.75
        //randomize the start position of each duck
        self.startPos = CGPoint(x: CGFloat(arc4random_uniform(550) + 750), y: CGFloat(arc4random_uniform(200) + 1750))
        
        //init the audio
        do{
            try quackSFX1 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: quackSound1!))
        } catch{
            print("QUACK SOUND 1 CANNOT BE FOUND!")
        }
        do{
            try quackSFX2 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: quackSound2!))
        } catch{
            print("QUACK SOUND 2 CANNOT BE FOUND!")
        }
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been found")
    }
    
    // Update is called every frame and holds the main functionality of the duck
    override func update(_ deltaTime: TimeInterval) {
        super.update(deltaTime)
        playQuackSound()
        //check if the duck is killed
        checkDead(deltaTime)
    }
    fileprivate func checkDead(_ deltaTime: TimeInterval){
        if isDead {
            //if the duck is dead, then 'disppear', just reset the position to the top again
            position = CGPoint(x: CGFloat(arc4random_uniform(550) + 750), y: CGFloat(arc4random_uniform(800) + 1750))
            //once the duck has been reset, then the boolean will go back to being false
            isDead = false
            return
        }
        //if the duck is not dead, then the duck will continue to fall
        if(position.y < 0){
            //if the position is less than the bottom of the screen, then the player loses
            gameOver = true
        }
        else{
            if(gameOver){
                return
            }
            //the duck continues falling
            position.y -= vel * CGFloat(deltaTime)
        }
    }
    public func killDuck(){
        //just sets the status of the duck to true, meaning DEAD
        isDead = true
    }
    fileprivate func playQuackSound(){
        if(!gameOver){ //as long as the game is not over, it will pplay the audio sounds for the duck under these conditions
            if(position.y < 1750 && position.y > 1600){
                // Play an explosion sound effect at random
                let rand = Int(arc4random_uniform(2))
                switch rand {
                case 0:
                    quackSFX1.play()
                    break
                case 1:
                    quackSFX2.play()
                    break
                default:
                    print("Major error in Duck.swift for randomizing sound effects")
                }
            }
        }
    }
}
