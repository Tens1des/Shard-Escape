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
    let scale: CGFloat
    
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
                .frame(height: 34 * scale)
                .padding(.bottom, 8 * scale)
            
            // Панель улучшения
            ZStack {
                Image("upgrade_panel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200 * scale)
                
                VStack(spacing: 30 * scale) {
                   
                    
                    // Иконка мяча
                    Image("ballUp_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64 * scale, height: 64 * scale)
                        .padding(.vertical, 8 * scale)
                    
                    // Цена
                    HStack {
                        Image("coin_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 10 * scale, height: 10 * scale)
                        
                        Text(ballSpeedLevel < maxLevel ? "\(currentCost)" : "MAX")
                            .font(.system(size: 18 * scale, weight: .bold))
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
                            .frame(height: 34 * scale)
                    }
                    .disabled(ballSpeedLevel >= maxLevel || totalCoins < currentCost)
                    
                    // Прогресс квадратики
                    HStack(spacing: 6 * scale) {
                        ForEach(0..<maxLevel, id: \.self) { index in
                            Image(ballSpeedLevel > index ? "orangUp_square" : "grayUp_square")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * scale, height: 24 * scale)
                        }
                    }
                    .padding(.bottom, 14 * scale)
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

/*#Preview {
    UpgradesSection(totalCoins: .constant(500))
        .background(Color.black)
}*/
 
