//
//  NavBarView.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SwiftUI

struct NavBarView: View {
    let money: Int
    let onSettingsTap: () -> Void
    let onPauseTap: () -> Void
    let isMainMenu: Bool
    let record: Int
    
    var body: some View {
        HStack {
            if isMainMenu {
                // Кнопка настроек слева (главное меню)
                Button(action: onSettingsTap) {
                    Image("settings_button")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                }
                
                Spacer()
                
                // Панель денег по центру (главное меню)
                MoneyPanelView(money: money)
                
                Spacer()
                
                // Справа ничего, рекорд убран из главного меню
                Color.clear.frame(width: 40, height: 40).opacity(0)
            } else {
                // Кнопка паузы слева (игровой экран)
                Button(action: onPauseTap) {
                    Image("pause_button")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                }
                
                Spacer()
                
                // Рекорд по центру (игровой экран)
                Text("SCORE: \(record)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                
                Spacer()
                
                // Панель денег справа (игровой экран)
                MoneyPanelView(money: money)
            }
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
        NavBarView(money: 0, onSettingsTap: {}, onPauseTap: {}, isMainMenu: true, record: 1000)
        Spacer()
    }
    .background(Color.blue)
}
