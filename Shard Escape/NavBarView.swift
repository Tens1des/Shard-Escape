//
//  NavBarView.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SwiftUI

struct NavBarView: View {
    @State private var money: Int = 100
    let onSettingsTap: () -> Void
    
    var body: some View {
        HStack {
            // Кнопка настроек слева
            Button(action: onSettingsTap) {
                Image("settings_button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }
            
            Spacer()
            
            // Панель денег по центру
            MoneyPanelView(money: money)
            
            Spacer()
            
            // Пустое место справа для балансировки
            Color.clear
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
       
    }
}

struct MoneyPanelView: View {
    let money: Int
    
    var body: some View {
        ZStack {
            // Фоновое изображение money_panel
            Image("money_panel")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 40)
            
            // Текст с количеством денег поверх панели
            Text("\(money)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 1, y: 1)
        }
    }
}

#Preview {
    VStack {
        NavBarView(onSettingsTap: {})
        Spacer()
    }
    .background(Color.blue)
}
