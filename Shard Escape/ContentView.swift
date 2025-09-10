//
//  ContentView.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var isGameActive = false
    
    var body: some View {
        if isGameActive {
            GameView(isGameActive: $isGameActive)
        } else {
            MainMenuView(isGameActive: $isGameActive)
        }
    }
}

// Сохраняем компоненты для игровой сцены на будущее
struct SKViewRepresentable: UIViewRepresentable {
    var scene: SKScene
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.isMultipleTouchEnabled = true
        view.presentScene(scene)
        print("SKView created and scene presented")
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Обновления, если необходимо
    }
}

// Отдельное представление для игровой сцены и интерфейса
struct GameSceneView: View {
    @ObservedObject var scene: GameScene
    
    var body: some View {
        ZStack {
            // Игровая сцена
            SKViewRepresentable(scene: scene)
                .ignoresSafeArea(.all, edges: .all)
            
            // Игровой интерфейс поверх сцены
            VStack {
                // Здесь будет игровой интерфейс сцены
                Spacer()
            }
        }
        .onAppear {
            print("GameSceneView appeared")
        }
    }
}

#Preview {
    ContentView()
}
