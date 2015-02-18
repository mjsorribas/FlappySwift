//
//  Background.swift
//  FlappySwift
//
//  Created by Giordano Scalzo on 26/08/2014.
//  Copyright (c) 2014 Effective Code. All rights reserved.
//

import SpriteKit

class Background {
    private let parallaxNode: ParallaxNode
    private let duration: Double

    init(textureNamed textureName: String, duration: Double) {
        parallaxNode = ParallaxNode(textureNamed: textureName)
        self.duration = duration
    }
    
    func addTo(parentNode: SKSpriteNode!) -> Background {
        parallaxNode.addTo(parentNode)
        return self
    }
}

// Startable
extension Background : Startable {
    func start() -> Startable {
        parallaxNode.start(duration: duration)
        return self
    }
    
    func stop() -> Startable {
        parallaxNode.stop()
        return self
    }
}