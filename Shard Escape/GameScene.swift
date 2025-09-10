//
//  GameScene.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, ObservableObject {
    @Published var money: Int = 100
    @Published var record: Int = 0
    
    override init(size: CGSize) {
        super.init(size: size)
        print("GameScene init with size: \(size)")
        setupScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScene()
    }
    
    override func didMove(to view: SKView) {
        print("GameScene didMove to view")
        // Дополнительная настройка при добавлении на view
    }
    
    private func setupScene() {
        print("Setting up GameScene")
        
        // Устанавливаем фон игры
        let background = SKSpriteNode(imageNamed: "game_bg")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = frame.size
        background.zPosition = -1
        addChild(background)
        print("Background added to scene")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Обработка касаний (можно добавить позже)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Обновление сцены (можно добавить позже)
    }
}
