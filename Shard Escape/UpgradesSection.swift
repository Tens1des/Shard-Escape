//
//  UpgradesSection.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SwiftUI

struct UpgradesSection: View {
    @Binding var totalCoins: Int
    @State private var ballSpeedLevel: Int = 0
    
    private let maxLevel: Int = 5
    private let baseCost: Int = 100
    private let baseSpeed: CGFloat = 250.0
    private let speedIncrement: CGFloat = 50.0
    
    private var currentCost: Int {
        baseCost * (ballSpeedLevel + 1)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок UPGRADES
            Image("upgrades_label")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 40)
                .padding(.bottom, 10)
            
            // Панель улучшения
            ZStack {
                Image("upgrade_panel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200)
                
                VStack(spacing: 20) {
                   
                    
                    // Иконка мяча
                    Image("ballUp_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .padding(.vertical, 10)
                    
                    // Цена
                    HStack {
                        Image("coin_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 10, height: 10)
                        
                        Text(ballSpeedLevel < maxLevel ? "\(currentCost)" : "MAX")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    // Кнопка покупки
                    Button(action: {
                        buyUpgrade()
                    }) {
                        Image("buy_button")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 40)
                    }
                    .disabled(ballSpeedLevel >= maxLevel || totalCoins < currentCost)
                    
                    // Прогресс квадратики
                    HStack(spacing: 8) {
                        ForEach(0..<maxLevel, id: \.self) { index in
                            Image(ballSpeedLevel > index ? "orangUp_square" : "grayUp_square")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .padding(.bottom, 0) // Небольшой отступ сверху к навбару
        .onAppear {
            loadUpgradeState()
        }
    }
    
    private func loadUpgradeState() {
        ballSpeedLevel = UserDefaults.standard.integer(forKey: "ballSpeedLevel")
    }
    
    private func buyUpgrade() {
        if ballSpeedLevel < maxLevel && totalCoins >= currentCost {
            totalCoins -= currentCost
            ballSpeedLevel += 1
            
            // Сохраняем все данные
            UserDefaults.standard.set(ballSpeedLevel, forKey: "ballSpeedLevel")
            UserDefaults.standard.set(totalCoins, forKey: "totalCoins")
            
            let newSpeed = baseSpeed + (CGFloat(ballSpeedLevel) * speedIncrement)
            UserDefaults.standard.set(newSpeed, forKey: "playerSpeed")
            
            // Уведомляем другие части приложения
            NotificationCenter.default.post(name: Notification.Name("CoinsUpdated"), object: totalCoins)
            
            print("Ball Speed upgraded to level \(ballSpeedLevel). New speed: \(newSpeed)")
        }
    }
}

#Preview {
    UpgradesSection(totalCoins: .constant(500))
        .background(Color.black)
}
