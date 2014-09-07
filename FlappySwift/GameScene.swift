//
//  GameScene.swift
//  FlappySwift
//
//  Created by Giordano Scalzo on 02/06/2014.
//  Copyright (c) 2014 Effective Code. All rights reserved.
//

import SpriteKit

enum BodyType : UInt32 {
    case bird = 1
    case world = 2
    case pipe = 4
    case gap = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var screenNode: SKSpriteNode!
    var bird: Bird!
    var actors: [Startable]!
    var score: Score!
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -3)
        
        screenNode = SKSpriteNode(color: UIColor.clearColor(), size: self.size)
        addChild(screenNode)
        
        let textures = Textures.cave()
        let bg = Background(texture: textures.background).addTo(screenNode)
        let te = Ground(texture: textures.ground).addTo(screenNode)
        bird = Bird(textures: textures.bird).addTo(screenNode).position(CGPointMake(30.0, 400.0))
        let pi = Pipes(textures: textures.pipes).addTo(screenNode)
        actors = [bg, te, pi, bird]
        
        score = Score().addTo(screenNode)

        for actor in actors {
            actor.start()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        bird.flap()
                    explode()

    }
    
    override func update(currentTime: CFTimeInterval) {
        bird.update()
    }
    
    func didBeginContact(contact: SKPhysicsContact!) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch (contactMask) {
        case BodyType.pipe.toRaw() |  BodyType.bird.toRaw():
            bird.pushDown()
        case BodyType.world.toRaw() | BodyType.bird.toRaw():
            for actor in actors {
                actor.stop()
            }
            
            let shakeAction = SKAction.shake(0.1, amplitudeX: 20)
            screenNode.runAction(shakeAction)
            
        default:
            return
        }
        
    }
    
    func didEndContact(contact: SKPhysicsContact!) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch (contactMask) {
        case BodyType.gap.toRaw() |  BodyType.bird.toRaw():
            score.increase()
//            explode()
        default:
            return
        }
    }

    private func explosionUp() {
        let emitterName = "explosionUp"
        let fireEmmitter = SKEmitterNode.emitterNodeWithName(emitterName)
        fireEmmitter.position = bird.position()
        screenNode.addChild(fireEmmitter)
    
        fireEmmitter.runAction(SKAction.sequence(
        [
            SKAction.moveByX(0, y: 1000, duration: 1),
            SKAction.removeFromParent()
        ]))
    }
    
    private func explosionDown() {
        let emitterName = "ExplosionDown"
        let fireEmmitter = SKEmitterNode.emitterNodeWithName(emitterName)
        fireEmmitter.position = bird.position()
        screenNode.addChild(fireEmmitter)
    
        fireEmmitter.runAction(SKAction.sequence(
        [
            SKAction.moveByX(0, y: -1000, duration: 1),
            SKAction.removeFromParent()
        ]))
    }
    
    private func explode() {
        explosionUp()
        explosionDown()
    }
    
}


