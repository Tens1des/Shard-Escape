import SpriteKit
import GameplayKit

// Структура для категорий физических объектов
struct PhysicsCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 0b1 // 1
    static let wall: UInt32 = 0b10 // 2
    static let hazard: UInt32 = 0b100 // 4
    static let collectible: UInt32 = 0b1000 // 8
    static let lava: UInt32 = 0b10000 // 16
}

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    @Published var money: Int = 100
    @Published var record: Int = 0
    
    private var lavaNode: SKSpriteNode?
    private var lavaSpeed: CGFloat = 20.0
    private var lastUpdateTime: TimeInterval = 0
    
    private var playerNode: SKSpriteNode?
    private var playerSpeed: CGFloat = 250.0
    private var isGameOver: Bool = false
    private var scoreTimer: Timer?
    private var currentScore: Int = 0
    private var totalCoins: Int = 0
    
    // Enum для типов шипов
    enum SpikeType: String {
        case up = "upKol_image"
        case down = "downKol_image"
        case left = "leftKol_image"
        case right = "rightKol_image"
    }
    
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
        let background = SKSpriteNode(imageNamed: "game_bg")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = frame.size
        background.zPosition = -1
        addChild(background)
        
        loadCoins()
        setupPhysics()
        setupLava()
        setupPlayer()
        setupLevel()
        startScoreTimer()
    }
    
    private func setupPhysics() {
        physicsWorld.contactDelegate = self
        // Устанавливаем гравитацию (если нужно, чтобы шар падал)
        // physicsWorld.gravity = CGVector(dx: 0, dy: -2.0) // Гравитация отключена
    }
    
    private func setupLava() {
        lavaNode = SKSpriteNode(imageNamed: "lava_image")
        guard let lava = lavaNode else { return }
        
        lava.size = CGSize(width: frame.width, height: frame.height * 1.5)
        lava.position = CGPoint(x: frame.midX, y: -frame.height * 1)
        lava.zPosition = 0
        
        // Добавляем физическое тело лаве
        lava.physicsBody = SKPhysicsBody(rectangleOf: lava.size)
        lava.physicsBody?.isDynamic = false
        lava.physicsBody?.categoryBitMask = PhysicsCategory.lava
        
        addChild(lava)
    }
    
    private func setupPlayer() {
        // Загружаем имя текстуры выбранного скина
        let selectedTexture = UserDefaults.standard.string(forKey: "selectedBallTexture") ?? "ball_user"
        playerNode = SKSpriteNode(imageNamed: selectedTexture)
        
        guard let player = playerNode else { return }
        
        // Загружаем сохраненную скорость
        let savedSpeed = UserDefaults.standard.double(forKey: "playerSpeed")
        if savedSpeed > 0 {
            playerSpeed = CGFloat(savedSpeed)
        }
        
        player.size = CGSize(width: 40, height: 40)
        player.position = CGPoint(x: frame.midX, y: 150) // Стартуем чуть выше
        player.zPosition = 2
        
        // Настройка физического тела
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false // Управляется джойстиком, не гравитацией
        player.physicsBody?.allowsRotation = false // Вращение отключено
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.hazard | PhysicsCategory.collectible | PhysicsCategory.lava
        player.physicsBody?.collisionBitMask = PhysicsCategory.wall
        
        addChild(player)
    }
    
    private func setupLevel() {
        // Уровень стал сложнее и выше
        let wallThickness: CGFloat = 40
        
        // Внешние стены
        createWall(at: CGPoint(x: frame.minX + wallThickness/2, y: frame.midY), size: CGSize(width: wallThickness, height: frame.height * 2))
        createWall(at: CGPoint(x: frame.maxX - wallThickness/2, y: frame.midY), size: CGSize(width: wallThickness, height: frame.height * 2))
        
        // --- Секция 1 ---
        createWall(at: CGPoint(x: frame.midX, y: 120), size: CGSize(width: 250, height: 20))
        // createHazard(at: CGPoint(x: frame.midX, y: 135), type: .up) // Убраны самые нижние шипы
        
        // --- Секция 2 ---
        createWall(at: CGPoint(x: frame.midX - 100, y: 300), size: CGSize(width: 200, height: 20))
        createHazard(at: CGPoint(x: frame.midX - 140, y: 340), type: .left, size: CGSize(width: 50, height: 50)) // Изменено
        createCollectible(at: CGPoint(x: frame.midX - 100, y: 330))
        
        // --- Секция 3 ---
        createWall(at: CGPoint(x: frame.midX + 100, y: 450), size: CGSize(width: 200, height: 20))
        createHazard(at: CGPoint(x: frame.midX + 140, y: 490), type: .right, size: CGSize(width: 50, height: 50)) // Изменено
        
        // --- Секция 4 ---
        // createWall(at: CGPoint(x: frame.midX, y: 600), size: CGSize(width: 20, height: 250)) // Стена убрана
        
        // --- Секция 5 ---
        createWall(at: CGPoint(x: frame.midX - 100, y: 750), size: CGSize(width: 150, height: 20))
        createHazard(at: CGPoint(x: frame.midX - 70, y: 785), type: .down, size: CGSize(width: 50, height: 50)) // Изменено
        createCollectible(at: CGPoint(x: frame.midX - 120, y: 780))
        
        // --- Секция 6 ---
        // createWall(at: CGPoint(x: frame.midX + 80, y: 900), size: CGSize(width: 150, height: 20))
        //createHazard(at: CGPoint(x: frame.midX + 20, y: 910), type: .right, size: CGSize(width: 50, height: 50)) // Изменено
    }
    
    private func createWall(at position: CGPoint, size: CGSize) {
        let wall = SKSpriteNode(color: .gray, size: size)
        wall.position = position
        wall.zPosition = 1
        
        wall.physicsBody = SKPhysicsBody(rectangleOf: size)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        
        addChild(wall)
    }
    
    private func createHazard(at position: CGPoint, type: SpikeType, size: CGSize = CGSize(width: 40, height: 40)) {
        let hazard = SKSpriteNode(imageNamed: type.rawValue)
        hazard.size = size // Используем переданный размер
        hazard.position = position
        hazard.zPosition = 1
        
        hazard.physicsBody = SKPhysicsBody(rectangleOf: hazard.size)
        hazard.physicsBody?.isDynamic = false
        hazard.physicsBody?.categoryBitMask = PhysicsCategory.hazard
        
        addChild(hazard)
    }
    
    private func createCollectible(at position: CGPoint) {
        let coin = SKSpriteNode(imageNamed: "coin_icon") // Предполагаем, что есть такая иконка
        coin.size = CGSize(width: 30, height: 30)
        coin.position = position
        coin.zPosition = 1
        
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.width / 2)
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.categoryBitMask = PhysicsCategory.collectible
        
        addChild(coin)
    }
    
    // MARK: - Coin System
    
    private func loadCoins() {
        totalCoins = UserDefaults.standard.integer(forKey: "totalCoins")
        updateCoinDisplay()
    }
    
    private func addCoins(_ amount: Int) {
        totalCoins += amount
        UserDefaults.standard.set(totalCoins, forKey: "totalCoins")
        updateCoinDisplay()
    }
    
    private func updateCoinDisplay() {
        // Отправляем уведомление об обновлении монет
        NotificationCenter.default.post(name: Notification.Name("CoinsUpdated"), object: totalCoins)
    }
    
    // MARK: - Score System
    
    private func startScoreTimer() {
        scoreTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.addScore()
        }
    }
    
    private func addScore() {
        guard !isGameOver, !self.isPaused else { return } // Проверяем встроенное свойство паузы
        currentScore += 5
        record = currentScore
        
        // Сохраняем рекорд в UserDefaults
        UserDefaults.standard.set(currentScore, forKey: "highScore")
        
        // Отправляем уведомление об обновлении счета
        NotificationCenter.default.post(name: Notification.Name("ScoreUpdated"), object: currentScore)
    }
    
    private func stopScoreTimer() {
        scoreTimer?.invalidate()
        scoreTimer = nil
    }
    
    // MARK: - Pause System
    
    func pauseGame() {
        self.isPaused = true // Используем встроенную паузу сцены
    }
    
    func resumeGame() {
        self.isPaused = false // Выключаем встроенную паузу
    }
    
    func restartLevel() {
        // Мягкий перезапуск: сбрасываем состояние, не создавая новую сцену
        self.isPaused = false
        isGameOver = false
        currentScore = 0
        record = 0
        
        // Сбрасываем таймер
        stopScoreTimer()
        startScoreTimer()
        
        // Удаляем только объекты уровня (стены, шипы, монеты)
        self.children.forEach { node in
            if node.physicsBody?.categoryBitMask == PhysicsCategory.wall ||
               node.physicsBody?.categoryBitMask == PhysicsCategory.hazard ||
               node.physicsBody?.categoryBitMask == PhysicsCategory.collectible {
                node.removeFromParent()
            }
        }
        
        // Сбрасываем игрока и лаву
        playerNode?.position = CGPoint(x: frame.midX, y: 150)
        playerNode?.physicsBody?.velocity = .zero
        lavaNode?.position = CGPoint(x: frame.midX, y: -frame.height * 1)
        
        // Создаем уровень заново
        setupLevel()
        
        // Обновляем счет в UI
        NotificationCenter.default.post(name: Notification.Name("ScoreUpdated"), object: 0)
    }
    
    private func restartGame() {
        // Полный перезапуск для Game Over
        if let view = self.view {
            let newScene = GameScene(size: self.size)
            newScene.scaleMode = self.scaleMode
            let transition = SKTransition.fade(withDuration: 0.5)
            view.presentScene(newScene, transition: transition)
        }
    }
    
    // MARK: - Game Loop
    
    override func update(_ currentTime: TimeInterval) {
        // guard !isGamePaused, let lava = lavaNode else { return } // Больше не нужно, isPaused остановит update
        guard let lava = lavaNode else { return }
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        let deltaY = lavaSpeed * CGFloat(deltaTime)
        lava.position.y += deltaY
        
        if lava.position.y > frame.height + lava.size.height * 0.5 {
            lava.position.y = -frame.height * 1
        }
    }
    
    // MARK: - Player Movement
    
    func movePlayer(direction: CGPoint) {
        // guard !isGameOver, !isGamePaused, let playerBody = playerNode?.physicsBody else { return } // Больше не нужно
        guard !isGameOver, let playerBody = playerNode?.physicsBody else { return }
        
        // Возвращаем прямое управление скоростью
        let velocity = CGVector(dx: direction.x * playerSpeed, dy: direction.y * playerSpeed)
        playerBody.velocity = velocity
    }
    
    // MARK: - Contact Delegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        // guard !isGamePaused else { return } // Больше не нужно
        
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Здесь будет логика столкновений
        if (firstBody.categoryBitMask == PhysicsCategory.player &&
            secondBody.categoryBitMask == PhysicsCategory.hazard) ||
           (firstBody.categoryBitMask == PhysicsCategory.player &&
            secondBody.categoryBitMask == PhysicsCategory.lava) {
            print("Player hit a hazard or lava!")
            gameOver()
        }
        
        if (firstBody.categoryBitMask == PhysicsCategory.player &&
            secondBody.categoryBitMask == PhysicsCategory.collectible) {
            print("Player collected a coin!")
            addCoins(50) // Добавляем 50 монет
            secondBody.node?.removeFromParent()
        }
    }
    
    // MARK: - Game Over
    
    private func gameOver() {
        guard !isGameOver else { return } // Предотвращаем двойной вызов
        isGameOver = true
        self.isPaused = true // Останавливаем сцену
        stopScoreTimer()
        
        // Отправляем уведомление о проигрыше с финальным счетом
        NotificationCenter.default.post(name: Notification.Name("GameOver"), object: currentScore)
    }
    
    func setLavaSpeed(_ speed: CGFloat) {
        lavaSpeed = speed
    }
    
    func resetLava() {
        lavaNode?.position.y = -frame.height * 1
    }
    
    deinit {
        stopScoreTimer()
    }
}
