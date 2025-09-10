import SwiftUI

struct PauseAlertView: View {
    @Binding var isPresented: Bool
    var onRestart: () -> Void
    var onResume: () -> Void
    var onHome: () -> Void
    @State private var soundValue: Double = 0.7
    @State private var musicValue: Double = 0.6
    
    var body: some View {
        ZStack {
            // Полупрозрачный затемнённый фон
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }
            
            // Панель паузы
            ZStack {
                Image("pause_panel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 500)
                
                VStack(alignment: .leading, spacing: 4) {
                    // Отступ сверху под декоративные элементы панели
                    Spacer().frame(height: 40)
                    
                    SettingsRow(title: "SOUND", value: $soundValue)
                    SettingsRow(title: "MUSIC", value: $musicValue)
                    
                    Spacer().frame(height: 10)
                    
                    // Ряд кнопок: restart, resume, home
                    HStack(spacing: 28) {
                        Button(action: {
                            isPresented = false
                            onRestart()
                        }) {
                            Image("restart_button")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 64)
                        }
                        
                        Button(action: {
                            isPresented = false
                            onResume()
                        }) {
                            Image("enter_button")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 64)
                        }
                        
                        Button(action: {
                            isPresented = false
                            onHome()
                        }) {
                            Image("home_button")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 64)
                        }
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

#Preview {
    StatefulPreviewWrapper(true) { shown in
        PauseAlertView(isPresented: shown, onRestart: {}, onResume: {}, onHome: {})
    }
} 