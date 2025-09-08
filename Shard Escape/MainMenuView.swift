//
//  MainMenuView.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Фоновое изображение
                Image("main_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Навигационная панель сверху с учетом SafeArea
                    NavBarView(onSettingsTap: {
                        // Действие для настроек
                        print("Settings tapped")
                    })
                    .padding(.top, geometry.safeAreaInsets.top > 0 ? geometry.safeAreaInsets.top : 100)
                    
                    // Основной контент меню
                    VStack(spacing: 30) {
                        Spacer()
                        
                        // Кнопки по центру экрана
                        VStack(spacing: 20) {
                            // Кнопка игры
                            Button(action: {
                                // Действие для начала игры
                                print("Play button tapped")
                            }) {
                                Image("play_button")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 80)
                            }
                            
                            // Кнопка магазина
                            Button(action: {
                                // Действие для магазина
                                print("Shop button tapped")
                            }) {
                                Image("shop_button")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 60)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

#Preview {
    MainMenuView()
}
