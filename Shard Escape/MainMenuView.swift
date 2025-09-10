//
//  MainMenuView.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SwiftUI

struct MainMenuView: View {
    @Binding var isGameActive: Bool
    @State private var showSettings: Bool = false
    @State private var showShop: Bool = false
    @State private var highScore: Int = 0
    @State private var totalCoins: Int = 0
    
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
                    NavBarView(
                        money: totalCoins,
                        onSettingsTap: {
                            showSettings = true
                        },
                        onPauseTap: {
                            // В главном меню пауза не нужна, но параметр обязательный
                        },
                        isMainMenu: true,
                        record: highScore
                    )
                    .padding(.top, geometry.safeAreaInsets.top > 0 ? geometry.safeAreaInsets.top : 50)
                    
                    // Основной контент меню
                    VStack(spacing: 30) {
                        Spacer()
                        
                        // Кнопки по центру экрана
                        VStack(spacing: 20) {
                            // Кнопка игры
                            Button(action: {
                                isGameActive = true
                            }) {
                                Image("play_button")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 80)
                            }
                            
                            // Кнопка магазина
                            Button(action: {
                                showShop = true
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
                
                // Магазин поверх
                if showShop {
                    ShopView(isPresented: $showShop)
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut(duration: 0.25), value: showShop)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            loadData()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("CoinsUpdated"))) { _ in
            loadData() // Перезагружаем данные при обновлении монет
        }
    }
    
    private func loadData() {
        highScore = UserDefaults.standard.integer(forKey: "highScore")
        totalCoins = UserDefaults.standard.integer(forKey: "totalCoins")
    }
}

#Preview {
    MainMenuView(isGameActive: .constant(false))
}
