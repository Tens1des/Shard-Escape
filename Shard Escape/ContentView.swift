//
//  ContentView.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        MainMenuView()
    }
}

// Сохраняем компоненты для игровой сцены на будущее
struct SKViewRepresentable: UIViewRepresentable {
    var scene: SKScene
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.isMultipleTouchEnabled = true
        view.presentScene(scene)
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
                .ignoresSafeArea()
            
            // Игровой интерфейс поверх сцены
            VStack {
                // Здесь будет игровой интерфейс сцены
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
