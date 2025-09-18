//
//  ShopView.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SwiftUI

// Выносим модель данных за пределы View для лучшей организации
struct SkinData: Identifiable {
    let id: Int
    let icon: String
    let ballTexture: String
    let price: Int
    var isUnlocked: Bool
}

struct ShopView: View {
    @Binding var isPresented: Bool
    @State private var totalCoins: Int = 0
    @State private var selectedSkin: Int = 0
    
    var body: some View {
        ZStack {
            // Фоновое изображение
            Image("main_bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            // Навигационная панель с учетом SafeArea
            VStack(spacing: 0) {
                // Масштаб интерфейса под маленькие устройства
                let deviceWidth = UIScreen.main.bounds.width
                let baseWidth: CGFloat = 390 // iPhone 14 базовая ширина
                let scale: CGFloat = min(1.0, max(0.78, deviceWidth / baseWidth))
                ShopNavBarView(
                    money: totalCoins,
                    onHomeTap: {
                        isPresented = false
                    }
                )
                .padding(.top, 1) // Небольшой отступ от SafeArea
                
                // Секция улучшений под навбаром - теперь ближе
                UpgradesSection(totalCoins: $totalCoins, scale: scale)
                    .padding(.horizontal, 8 * scale)
                    .padding(.top, 4 * scale) // Минимальный отступ сверху
                
                // Секция скинов
                SkinsSection(totalCoins: $totalCoins, scale: scale)
                    .padding(.horizontal, 8 * scale)
                    .padding(.top, 10 * scale)
                
                Spacer()
            }
        }
        .onAppear {
            loadInitialData()
        }
    }
    
    private func loadInitialData() {
        totalCoins = UserDefaults.standard.integer(forKey: "totalCoins")
    }
}

// Компонент скинов
struct SkinsSection: View {
    @Binding var totalCoins: Int
    @State private var skins: [SkinData] = []
    @State private var selectedSkinID: Int = 0
    let scale: CGFloat
    
    var body: some View {
        VStack(spacing: 10 * scale) {
            
            // Горизонтальный скролл скинов
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12 * scale) {
                    ForEach($skins) { $skin in
                        SkinCard(
                            skin: $skin,
                            isSelected: skin.id == selectedSkinID,
                            scale: scale,
                            onTap: {
                                handleTap(on: skin)
                            }
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 10 * scale)
            }
        }
        .onAppear {
            loadSkins()
        }
    }
    
    private func handleTap(on skin: SkinData) {
        if skin.isUnlocked {
            // Если скин разблокирован, выбираем его
            selectSkin(skin)
        } else {
            // Если нет, пытаемся купить
            buySkin(skin)
        }
    }
    
    private func loadSkins() {
        // Загружаем сохраненные данные или устанавливаем по умолчанию
        let unlockedIDs = UserDefaults.standard.array(forKey: "unlockedSkinIDs") as? [Int] ?? [0]
        selectedSkinID = UserDefaults.standard.integer(forKey: "selectedSkinID")
        
        // Инициализируем базовый список скинов. ID 0 теперь - скин по умолчанию, не из магазина.
        self.skins = [
            SkinData(id: 1, icon: "skin1_icon", ballTexture: "skin1_ball", price: 100, isUnlocked: unlockedIDs.contains(1)), // Цену для первого можно поменять
            SkinData(id: 2, icon: "skin2_icon", ballTexture: "skin2_ball", price: 200, isUnlocked: unlockedIDs.contains(2)),
            SkinData(id: 3, icon: "skin3_icon", ballTexture: "skin3_ball", price: 300, isUnlocked: unlockedIDs.contains(3)),
            SkinData(id: 4, icon: "skin4_icon", ballTexture: "skin4_ball", price: 400, isUnlocked: unlockedIDs.contains(4))
        ]
        
        // Устанавливаем текстуру по умолчанию, если ничего не выбрано (например, при первом запуске)
        if UserDefaults.standard.string(forKey: "selectedBallTexture") == nil {
            UserDefaults.standard.set("ball_user", forKey: "selectedBallTexture")
        }
    }
    
    private func buySkin(_ skin: SkinData) {
        guard totalCoins >= skin.price else { return }
        
        totalCoins -= skin.price
        
        // Обновляем состояние в UI
        if let index = skins.firstIndex(where: { $0.id == skin.id }) {
            skins[index].isUnlocked = true
        }
        
        // Сразу выбираем купленный скин
        selectSkin(skin)
        
        // Сохраняем данные
        var unlockedIDs = UserDefaults.standard.array(forKey: "unlockedSkinIDs") as? [Int] ?? []
        if !unlockedIDs.contains(skin.id) {
            unlockedIDs.append(skin.id)
        }
        UserDefaults.standard.set(unlockedIDs, forKey: "unlockedSkinIDs")
        UserDefaults.standard.set(totalCoins, forKey: "totalCoins")
        NotificationCenter.default.post(name: Notification.Name("CoinsUpdated"), object: totalCoins)
    }
    
    private func selectSkin(_ skin: SkinData) {
        selectedSkinID = skin.id
        UserDefaults.standard.set(selectedSkinID, forKey: "selectedSkinID")
        
        // Сохраняем имя текстуры для игры
        UserDefaults.standard.set(skin.ballTexture, forKey: "selectedBallTexture")
    }
}

// Карточка скина
struct SkinCard: View {
    @Binding var skin: SkinData
    let isSelected: Bool
    let scale: CGFloat
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8 * scale) {
            // Панель скина
            ZStack {
                Image("skin_panel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120 * scale, height: 140 * scale)
                
                VStack(spacing: 6 * scale) {
                    // Иконка скина
                    Image(skin.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60 * scale, height: 60 * scale)
                        .padding(.top, 18 * scale)
                    
                   // Spacer()
                    
                    // Цена
                    HStack {
                        Image("coin_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12 * scale, height: 12 * scale)
                        
                        Text("\(skin.price)")
                            .font(.system(size: 16 * scale, weight: .bold))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    // Кнопка покупки/выбора
                    Button(action: onTap) {
                        if !skin.isUnlocked {
                            Image("buy_button")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 32 * scale)
                        } else if isSelected {
                            Image("inUse_button")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80 * scale, height: 32 * scale)
                        } else {
                            Image("use_button")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80 * scale, height: 32 * scale)
                        }
                    }
                    .padding(.bottom, 12 * scale)
                }
            }
        }
        .scaleEffect(isSelected ? min(1.05, 1.0 + 0.05 * scale) : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// Навигационная панель для магазина
struct ShopNavBarView: View {
    let money: Int
    let onHomeTap: () -> Void
    
    var body: some View {
        HStack {
            // Кнопка домой слева
            Button(action: onHomeTap) {
                Image("home_button")
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
        .padding(.vertical, 50)
    }
}

#Preview {
    StatefulPreviewWrapper(true) { isShown in
        ShopView(isPresented: isShown)
    }
}
