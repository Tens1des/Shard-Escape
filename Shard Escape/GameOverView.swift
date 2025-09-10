import SwiftUI

struct GameOverView: View {
    let score: Int
    let coinsEarned: Int
    let onHome: () -> Void
    let onRestart: () -> Void
    
    var body: some View {
        ZStack {
            // Полупрозрачный фон
            Color.black.opacity(0.7).ignoresSafeArea()
            
            // Панель Game Over
            ZStack {
                Image("gameOver_panel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 500)
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Итоговый счет
                    Text("\(score)")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 5)
                    
                    // Заработанные монеты
                    HStack(spacing: 10) {
                        Text("+\(coinsEarned)")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        
                        Image("coin_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 40)
                    }
                    
                    // Кнопки
                    HStack(spacing: 40) {
                        Button(action: onHome) {
                            Image("home_button")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 80)
                        }
                        
                        Button(action: onRestart) {
                            Image("restart_button")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 80)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 60) // Отступ для надписи "Game Over"
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    GameOverView(score: 82134, coinsEarned: 100, onHome: {}, onRestart: {})
} 