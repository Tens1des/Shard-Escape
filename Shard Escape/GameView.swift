import SwiftUI
import SpriteKit
import Combine

struct GameView: View {
    @Binding var isGameActive: Bool
    @State private var showTutorial: Bool = true
    @State private var money: Int = 0 // Начинаем с 0
    @State private var record: Int = 0
    @State private var isPaused: Bool = false
    @State private var gameScene: GameScene?
    @State private var showGameOver: Bool = false
    @State private var finalScore: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let scene = gameScene {
                    SKViewRepresentable(scene: scene)
                        .ignoresSafeArea()
                }
                
                VStack {
                    NavBarView(
                        money: money,
                        onSettingsTap: {},
                        onPauseTap: { 
                            isPaused.toggle()
                            if isPaused {
                                gameScene?.pauseGame()
                            } else {
                                gameScene?.resumeGame()
                            }
                        },
                        isMainMenu: false,
                        record: record
                    )
                    .padding(.top, geometry.safeAreaInsets.top > 0 ? geometry.safeAreaInsets.top : 50)
                    
                    Spacer()
                    
                    if !showTutorial && !isPaused {
                        JoystickView { direction in
                            gameScene?.movePlayer(direction: direction)
                        }
                        .padding(.bottom, 30)
                    }
                }
                
                if showTutorial {
                    TutorialView(isPresented: $showTutorial)
                }
                
                if isPaused {
                    PauseAlertView(
                        isPresented: $isPaused,
                        onRestart: {
                            isPaused = false
                            gameScene?.restartLevel() // Используем мягкий перезапуск уровня
                        },
                        onResume: {
                            isPaused = false
                            gameScene?.resumeGame()
                        },
                        onHome: { 
                            isGameActive = false 
                        }
                    )
                }
                
                // Экран Game Over
                if showGameOver {
                    GameOverView(
                        score: finalScore,
                        coinsEarned: 100, // TODO: Передавать реальные монеты
                        onHome: {
                            isGameActive = false
                        },
                        onRestart: {
                            showGameOver = false
                            gameScene?.restartLevel()
                        }
                    )
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            gameScene = GameScene(size: UIScreen.main.bounds.size)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ScoreUpdated"))) { notification in
            if let newScore = notification.object as? Int {
                record = newScore
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("CoinsUpdated"))) { notification in
            if let newCoins = notification.object as? Int {
                money = newCoins
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GameOver"))) { notification in
            if let score = notification.object as? Int {
                finalScore = score
                showGameOver = true
            }
        }
    }
}
