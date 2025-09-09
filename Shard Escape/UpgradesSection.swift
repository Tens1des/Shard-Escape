//
//  UpgradesSection.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SwiftUI

struct UpgradesSection: View {
    @State private var ballSpeedLevel: Int = 0
    @State private var money: Int = 100
    let maxLevel: Int = 3
    
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
                        
                        Text("100")
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
                    .disabled(ballSpeedLevel >= maxLevel || money < 100)
                    
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
    }
    
    private func buyUpgrade() {
        if ballSpeedLevel < maxLevel && money >= 100 {
            ballSpeedLevel += 1
            money -= 100
            print("Ball Speed upgraded to level \(ballSpeedLevel)")
        }
    }
}

#Preview {
    UpgradesSection()
        .background(Color.black)
}
