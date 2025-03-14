//
//  StoreScene.swift
//  Alien-Attack
//
//  Created by Stuart McClintock on 7/24/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import Foundation
import SpriteKit

import AVFoundation

class StoreScene: SKScene{
    
    var del: AppDelegate!
    var audioPlayer: AVAudioPlayer?
    
    var userGoldLabel: SKLabelNode!
    var userMercLabel: SKLabelNode!
    
    let moneyGreen = SKColor.init(displayP3Red: 17/255, green: 125/255, blue: 7/255, alpha: 1)
    
    var compressed = true
    
    enum listingType{
        case mercenary
        case shotSpeed
    }
    
    class Listing{
        var type:listingType = .mercenary
        var goldRequired = 0
        var rewardFactor = 0
    }
    
    var listings:[Listing] = []
    var buyButtons:[SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
        let app = UIApplication.shared
        del = app.delegate as? AppDelegate
        
        self.backgroundColor = SKColor.white
        addBackButton()
        createListings()
        drawListings()
        displayUserHoldings()
    }
    
    func createListings(){
        let listing1 = Listing()
        listing1.goldRequired = 150
        listing1.rewardFactor = 1
        listings.append(listing1)
        
        let listing2 = Listing()
        listing2.goldRequired = 600
        listing2.rewardFactor = 5
        listings.append(listing2)
        
        let listing3 = Listing()
        listing3.goldRequired = 1000
        listing3.rewardFactor = 10
        listings.append(listing3)
        
        let listing4 = Listing()
        listing4.type = .shotSpeed
        listing4.goldRequired = 2500
        listing4.rewardFactor = 2
        listings.append(listing4)
    }
    
    func drawListings(){
        let innerGap:CGFloat = 150
        var firstGap:CGFloat = 150
        if UIDevice.current.model == "iPhone" && UIScreen.main.bounds.height > 800{
            compressed = false
            firstGap = 200
        }
        var yOffset = innerGap+firstGap
        
        var rowNum = 0
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let startLine = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: frame.maxY-firstGap))
        path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY-firstGap))
        startLine.path = path
        startLine.strokeColor = SKColor.black
        startLine.lineWidth = 3
        addChild(startLine)
        
        for curr in listings{
            let endLine = SKShapeNode()
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: frame.maxY-yOffset))
            path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY-yOffset))
            endLine.path = path
            endLine.strokeColor = SKColor.black
            endLine.lineWidth = 3
            addChild(endLine)
            
            let buyButton = SKSpriteNode()
            buyButton.size = CGSize(width: 130, height: 75)
            if del.numGold >= curr.goldRequired{
                buyButton.color = moneyGreen
            }
            else{
                buyButton.color = SKColor.darkGray
            }
            buyButton.position = CGPoint(x: frame.maxX-90, y: frame.maxY-yOffset+(innerGap/2))
            buyButton.name = "BUY\(rowNum)"
            buyButtons.append(buyButton)
            addChild(buyButton)
            let buyText = SKLabelNode(fontNamed: "DIN Alternate Bold")
            buyText.color = SKColor.white
            buyText.verticalAlignmentMode = .center
            buyText.position = CGPoint(x: frame.maxX-90, y: frame.maxY-yOffset+(innerGap/2))
            buyText.text = "BUY"
            buyText.fontSize = 52
            buyText.name = "BUY\(rowNum)"
            addChild(buyText)
            
            var goldX:CGFloat = 290
            
            if curr.type == .mercenary{
                let mercImage = SKSpriteNode(imageNamed: "mercenaryAlien-black")
                mercImage.size = CGSize(width: 100, height: 100)
                mercImage.position = CGPoint(x: 80, y: frame.maxY-yOffset+(innerGap/2))
                addChild(mercImage)
                let mercLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
                mercLabel.fontSize = 72
                mercLabel.fontColor = SKColor.black
                mercLabel.horizontalAlignmentMode = .left
                mercLabel.verticalAlignmentMode = .center
                mercLabel.position = CGPoint(x: 175, y: frame.maxY-yOffset+(innerGap/2))
                mercLabel.text = "\(curr.rewardFactor)"
                addChild(mercLabel)
            }
            else if curr.type == .shotSpeed{
                let gunImage = SKSpriteNode(imageNamed: "laserGun")
                gunImage.size = CGSize(width: 125, height: 125)
                gunImage.position = CGPoint(x: 75, y: frame.maxY-yOffset+(innerGap/2))
                addChild(gunImage)
                
                let speedText = SKLabelNode(fontNamed: "DIN Alternate Bold")
                speedText.fontSize = 46
                speedText.numberOfLines = 2
                speedText.fontColor = SKColor.black
                speedText.text = "Restore\nSpeed X\(curr.rewardFactor)"
                speedText.verticalAlignmentMode = .center
                speedText.horizontalAlignmentMode = .left
                speedText.position = CGPoint(x: 140, y: frame.maxY-yOffset+(innerGap/2))
                addChild(speedText)
                
                goldX = 390
            }
            
            let goldImage = SKSpriteNode(texture: del.coinFrames[0])
            goldImage.position = CGPoint(x: goldX, y: frame.maxY-yOffset+(innerGap/2))
            goldImage.size = CGSize(width:65, height:65)
            addChild(goldImage)
            goldImage.run(SKAction.repeatForever(SKAction.animate(with: del.coinFrames, timePerFrame: 0.04, resize: false, restore: true)), withKey: "rotatingCoin")
            
            let labelText = formatter.string(from: NSNumber(value:curr.goldRequired))
            let goldLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
            goldLabel.fontSize = 54
            goldLabel.fontColor = SKColor.black
            goldLabel.horizontalAlignmentMode = .left
            goldLabel.verticalAlignmentMode = .center
            goldLabel.position = CGPoint(x: goldX+50, y: frame.maxY-yOffset+(innerGap/2))
            goldLabel.text = labelText
            addChild(goldLabel)
            
            yOffset += innerGap
            rowNum += 1
        }
    }
    
    func updateUserLabels(){
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        userGoldLabel.text = formatter.string(from: NSNumber(value:del.numGold))
        userMercLabel.text = formatter.string(from: NSNumber(value:del.numMercs))
        if del.numMercs >= 10000{
            userMercLabel.fontSize = 38
        }
        if del.numGold >= 100000000000{
            userGoldLabel.fontSize = 38
        }
    }
    
    func displayUserHoldings(){
        /*var userGoldLabel: SKLabelNode
        var userMercLabel: SKLabelNode*/
        
        var yOffset:CGFloat = 115
        if compressed{
            yOffset = 75
        }
        
        let goldImage = SKSpriteNode(texture: del.coinFrames[0])
        goldImage.position = CGPoint(x: 60, y: frame.maxY-yOffset)
        goldImage.size = CGSize(width:75, height:75)
        addChild(goldImage)
        goldImage.run(SKAction.repeatForever(SKAction.animate(with: del.coinFrames, timePerFrame: 0.04, resize: false, restore: true)), withKey: "rotatingCoin")
        
        userGoldLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        userGoldLabel.verticalAlignmentMode = .center
        userGoldLabel.horizontalAlignmentMode = .left
        userGoldLabel.fontSize = 54
        userGoldLabel.fontColor = SKColor.black
        userGoldLabel.position = CGPoint(x: 125, y: frame.maxY-yOffset)
        addChild(userGoldLabel)
        
        userMercLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        userMercLabel.verticalAlignmentMode = .center
        userMercLabel.fontSize = 54
        userMercLabel.fontColor = SKColor.black
        userMercLabel.position = CGPoint(x: frame.maxX-125, y: frame.maxY-yOffset)
        addChild(userMercLabel)
        
        let mercImage = SKSpriteNode(imageNamed: "mercenaryAlien-black")
        mercImage.size = CGSize(width: 75, height: 75)
        mercImage.position = CGPoint(x: frame.maxX-200, y: frame.maxY-yOffset)
        addChild(mercImage)
        
        updateUserLabels()
    }
    
    func addBackButton(){
        let pos = CGPoint(x:frame.midX, y:160)
        
        let button = SKSpriteNode(color: SKColor.black, size: CGSize(width: 300, height: 100))
        button.name = "back"
        button.position = pos
        let buttonText = SKLabelNode(fontNamed: "DIN Alternate Bold")
        buttonText.text = "BACK"
        buttonText.name = "back"
        buttonText.fontSize = 62
        buttonText.color = SKColor.white
        buttonText.position = CGPoint(x:pos.x, y:pos.y-25.0)
        addChild(button)
        addChild(buttonText)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchedNode = atPoint(touch.location(in: self))
            let name:String = touchedNode.name ?? ""
            if name == "back"{
                returnToMain()
            }
            if (name.starts(with: "BUY")){
                let row = Int(name[name.index(name.startIndex, offsetBy:3)...])!
                print(row)
                buyPressed(row: row)
            }
        }
    }
    
    func buyPressed(row: Int){
        let selectedListing = listings[row]
        if selectedListing.goldRequired > del.numGold{
            tappedNoise(hasFunds: false)
            return
        }
        else{
            tappedNoise(hasFunds: true)
        }
        
        if selectedListing.type == .shotSpeed{
            del.regenTime /= 2
            UserDefaults.standard.set(del.regenTime, forKey: "regenTime")
        }
        else if selectedListing.type == .mercenary{
            del.numMercs += selectedListing.rewardFactor
            UserDefaults.standard.set(del.numMercs, forKey: "numMercs")
        }
        
        del.numGold -= selectedListing.goldRequired
        UserDefaults.standard.set(del.numGold, forKey: "numGold")
        
        
        updateUserLabels()
        updateButtonColors()
    }
    
    func tappedNoise(hasFunds: Bool){
        var fileName = "purchaseFailure"
        if hasFunds{
            fileName = "purchaseSuccess"
        }
        if (!del.isMute){
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
                try AVAudioSession.sharedInstance().setActive(true)
                
                let soundPath = Bundle.main.path(forResource: fileName, ofType: "mp3")
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
                audioPlayer?.play()
            }
            catch {}
        }
    }
    
    func updateButtonColors(){
        var buttonNum = 0
        for listing in listings{
            if listing.goldRequired <= del.numGold{
                buyButtons[buttonNum].color = moneyGreen
            }
            else{
                buyButtons[buttonNum].color = SKColor.darkGray
            }
            buttonNum += 1
        }
    }
    
    func returnToMain(){
        del.buttonSound()
        
        let modeScene = GameScene(fileNamed: "SelectModeScene")
        modeScene?.scaleMode = .aspectFill
        if UIDevice.current.model == "iPad"{
            modeScene?.scaleMode = .fill
        }
        self.view?.presentScene(modeScene!, transition: .doorsCloseVertical(withDuration: 0.4))
    }
}
