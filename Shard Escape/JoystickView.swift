import SwiftUI

struct JoystickView: View {
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging: Bool = false
    
    let onDirectionChange: (CGPoint) -> Void
    
    private let joystickRadius: CGFloat = 60
    private let thumbRadius: CGFloat = 25
    private let maxDistance: CGFloat = 35
    
    var body: some View {
        ZStack {
            Image("joystic_panel")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: joystickRadius * 2, height: joystickRadius * 2)
            
            Image("elipse_joystic")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: thumbRadius * 2, height: thumbRadius * 2)
                .offset(dragOffset)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isDragging = true
                            let distance = sqrt(value.translation.width * value.translation.width + value.translation.height * value.translation.height)
                            let limitedDistance = min(distance, maxDistance)
                            
                            if distance > 0 {
                                let angle = atan2(value.translation.height, value.translation.width)
                                dragOffset = CGSize(
                                    width: cos(angle) * limitedDistance,
                                    height: sin(angle) * limitedDistance
                                )
                            } else {
                                dragOffset = .zero
                            }
                            
                            let normalizedX = dragOffset.width / maxDistance
                            let normalizedY = -dragOffset.height / maxDistance
                            onDirectionChange(CGPoint(x: normalizedX, y: normalizedY))
                        }
                        .onEnded { _ in
                            isDragging = false
                            withAnimation(.easeOut(duration: 0.2)) {
                                dragOffset = .zero
                            }
                            onDirectionChange(CGPoint.zero)
                        }
                )
        }
        .opacity(isDragging ? 0.8 : 1.0)
    }
}
