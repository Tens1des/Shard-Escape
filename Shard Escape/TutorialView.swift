//
//  TutorialView.swift
//  Shard Escape
//
//  Created by Рома Котов on 08.09.2025.
//

import SwiftUI

struct TutorialView: View {
    @Binding var isPresented: Bool
    @State private var currentPage: Int = 0
    
    private let tutorialImages = ["tutorial1", "tutorial2", "tutorial3"]
    
    var body: some View {
        ZStack {
            // Полупрозрачный фон
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Изображение туториала на весь экран
                Image(tutorialImages[currentPage])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(.all, edges: .all)
                    .onTapGesture {
                        nextPage()
                    }
                
                // Индикаторы страниц внизу
                HStack(spacing: 10) {
                    ForEach(0..<tutorialImages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.bottom, 50)
                .background(Color.clear)
            }
        }
        .ignoresSafeArea(.all, edges: .all)
        .transition(.opacity.combined(with: .scale))
        .animation(.easeInOut(duration: 0.3), value: isPresented)
    }
    
    private func nextPage() {
        if currentPage < tutorialImages.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage += 1
            }
        } else {
            // Если это последняя страница, закрываем туториал
            withAnimation(.easeInOut(duration: 0.3)) {
                isPresented = false
            }
        }
    }
}

#Preview {
    TutorialView(isPresented: .constant(true))
}
