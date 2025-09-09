//
//  MainMenuView.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SwiftUI

struct MainMenuView: View {
    @State private var showSettings: Bool = false
    
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
                        showSettings = true
                    })
                    .padding(.top, geometry.safeAreaInsets.top > 0 ? geometry.safeAreaInsets.top : 0150)
                    
                    // Основной контент меню
                    VStack(spacing: 30) {
                        Spacer()
                        
                        // Кнопки по центру экрана
                        VStack(spacing: 20) {
                            // Кнопка игры
                            Button(action: {
                                print("Play button tapped")
                            }) {
                                Image("play_button")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 80)
                            }
                            
                            // Кнопка магазина
                            Button(action: {
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
                
                // Алерт настроек поверх
                if showSettings {
                    SettingsAlertView(isPresented: $showSettings)
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut(duration: 0.25), value: showSettings)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

#Preview {
    MainMenuView()
}
