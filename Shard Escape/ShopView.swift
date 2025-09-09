//
//  ShopView.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SwiftUI

struct ShopView: View {
    @Binding var isPresented: Bool
    @State private var money: Int = 100
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
                ShopNavBarView(
                    money: money,
                    onHomeTap: {
                        isPresented = false
                    }
                )
                .padding(.top, 1) // Небольшой отступ от SafeArea
                
                // Секция улучшений под навбаром - теперь ближе
                UpgradesSection()
                    .padding(.horizontal, 10)
                    .padding(.top, 5) // Минимальный отступ сверху
                
                // Секция скинов
                SkinsSection(selectedSkin: $selectedSkin, money: $money)
                    .padding(.horizontal, 10)
                    .padding(.top, 20)
                
                Spacer()
            }
        }
    }
}

// Компонент скинов
struct SkinsSection: View {
    @Binding var selectedSkin: Int
    @Binding var money: Int
    
    private let skins = [
        SkinData(icon: "skin1_icon", price: 100, isUnlocked: true),
        SkinData(icon: "skin2_icon", price: 200, isUnlocked: false),
        SkinData(icon: "skin3_icon", price: 300, isUnlocked: false),
        SkinData(icon: "skin4_icon", price: 400, isUnlocked: false)
    ]
    
    var body: some View {
        VStack(spacing: 15) {
            // Заголовок SKINS
            Text("SKINS")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(radius: 2)
            
            // Горизонтальный скролл скинов
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(Array(skins.enumerated()), id: \.offset) { index, skin in
                        SkinCard(
                            skin: skin,
                            isSelected: selectedSkin == index,
                            onTap: {
                                if skin.isUnlocked {
                                    selectedSkin = index
                                } else {
                                    buySkin(at: index, skin: skin)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func buySkin(at index: Int, skin: SkinData) {
        if money >= skin.price {
            money -= skin.price
            // Здесь можно добавить логику разблокировки скина
            print("Skin \(index + 1) purchased for \(skin.price) coins")
        }
    }
}

// Модель данных для скина
struct SkinData {
    let icon: String
    let price: Int
    let isUnlocked: Bool
}

// Карточка скина
struct SkinCard: View {
    let skin: SkinData
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            // Панель скина
            ZStack {
                Image("skin_panel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 160)
                
                VStack(spacing: 6) {
                    // Иконка скина
                    Image(skin.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .padding(.top, 20)
                    
                   // Spacer()
                    
                    // Цена
                    HStack {
                        Image("coin_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                        
                        Text("\(skin.price)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                   
                                        // Кнопка покупки/выбора
                                        Button(action: onTap) {
                                            Image("buy_button")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 35)
                                        }
                                       // .disabled(money < skin.price && !skin.isUnlocked)
                                        .padding(.bottom, 15)
                    // ... existing code ...
                    //.disabled(money < skin.price && !skin.isUnlocked)
                    .padding(.bottom, 15)
                }
            }
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
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
