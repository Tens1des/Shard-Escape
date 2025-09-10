//
//  GameView.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @Binding var isGameActive: Bool
    @State private var showTutorial: Bool = true
    @State private var money: Int = 100
    @State private var record: Int = 0
    @State private var isPaused: Bool = false
    @State private var gameScene: GameScene?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Игровая сцена
                if let scene = gameScene {
                    SKViewRepresentable(scene: scene)
                        .ignoresSafeArea()
                }
                
                // Навигационная панель поверх игры
                VStack {
                    NavBarView(
                        onSettingsTap: {
                            // Действие настроек
                        },
                        onPauseTap: {
                            isPaused.toggle()
                        },
                        isMainMenu: false
                    )
                    .padding(.top, geometry.safeAreaInsets.top > 0 ? geometry.safeAreaInsets.top : 50)
                    
                    Spacer()
                }
                
                // Туториал поверх всего
                if showTutorial {
                    TutorialView(isPresented: $showTutorial)
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut(duration: 0.25), value: showTutorial)
                }
                
                // Пауза поверх всего
                if isPaused {
                    PauseAlertView(
                        isPresented: $isPaused,
                        onRestart: {
                            // Пересоздать сцену
                            gameScene = GameScene(size: UIScreen.main.bounds.size)
                        },
                        onResume: {
                            // Просто продолжить
                        },
                        onHome: {
                            isGameActive = false
                        }
                    )
                    .transition(.opacity.combined(with: .scale))
                    .animation(.easeInOut(duration: 0.25), value: isPaused)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            // Создаем сцену с правильным размером
            gameScene = GameScene(size: UIScreen.main.bounds.size)
        }
    }
}

#Preview {
    GameView(isGameActive: .constant(true))
}
