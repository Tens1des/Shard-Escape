//
//  SettingsAlertView.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SwiftUI

struct SettingsAlertView: View {
    @Binding var isPresented: Bool
    @State private var soundValue: Double = 0.7
    @State private var musicValue: Double = 0.6
    
    var body: some View {
        ZStack {
            // Полупрозрачный затемнённый фон
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }
            
            // Панель настроек
            ZStack {
                Image("settings_panel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 500)
                
                VStack(alignment: .leading, spacing: 1) {
                    // Отступ сверху под декоративные элементы панели
                    Spacer().frame(height: 40)
                    
                    SettingsRow(title: "SOUND", value: $soundValue)
                    SettingsRow(title: "MUSIC", value: $musicValue)
                    
                    Spacer().frame(height: 0)
                    
                    // Кнопка Назад
                    Button(action: { isPresented = false }) {
                        Image("back_button")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 64)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer().frame(height: 16)
                }
                .padding(.horizontal, 32)
            }
            .padding(.horizontal, 24)
        }
    }
}

private struct SettingsRow: View {
    let title: String
    @Binding var value: Double
    
    var body: some View {
        HStack(spacing: 16) {
            Text(title)
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            CustomSlider(value: $value)
        }
    }
}

struct CustomSlider: View {
    @Binding var value: Double // 0...1
    
    private let barHeight: CGFloat = 28
    private let knobSize: CGSize = CGSize(width: 28, height: 52)
    
    var body: some View {
        GeometryReader { geo in
            let width = max(geo.size.width, knobSize.width)
            let progress = CGFloat(min(max(value, 0), 1))
            let knobX = progress * (width - knobSize.width)
            
            ZStack(alignment: .leading) {
                // Unfilled
                Image("unfill_bar")
                    .resizable()
                    .frame(height: barHeight)
                    .cornerRadius(barHeight/2)
                
                // Filled
                Image("fill_bar")
                    .resizable()
                    .frame(width: max(progress * width, knobSize.width * 0.6), height: barHeight)
                    .cornerRadius(barHeight/2)
                
                // Knob
                Image("slider_custom")
                    .resizable()
                    .frame(width: knobSize.width, height: knobSize.height)
                    .offset(x: knobX - (knobSize.width * 0.1), y: -(knobSize.height - barHeight)/10)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { g in
                            let clamped = min(max(0, g.location.x / width), 1)
                            value = Double(clamped)
                        }
                    )
            }
        }
        .frame(height: knobSize.height)
    }
}

#Preview {
    StatefulPreviewWrapper(true) { isShown in
        SettingsAlertView(isPresented: isShown)
    }
}

struct StatefulPreviewWrapper<Value, Content>: View where Content: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content
    
    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }
    
    var body: some View {
        content($value)
    }
}
