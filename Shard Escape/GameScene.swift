//
//  GameScene.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, ObservableObject {
    
    override func didMove(to view: SKView) {
        setupScene()
    }
    
    private func setupScene() {
        // Устанавливаем цвет фона
        backgroundColor = SKColor.black
        
        // Создаём текст "Hello!"
        let helloLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        helloLabel.text = "Hello!"
        helloLabel.fontSize = 48
        helloLabel.fontColor = SKColor.white
        helloLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        helloLabel.zPosition = 1
        
        addChild(helloLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Обработка касаний (можно добавить позже)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Обновление сцены (можно добавить позже)
    }
}
