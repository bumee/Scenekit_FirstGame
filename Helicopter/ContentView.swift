//  Copyright © 2020 Krassimir Iankov. All rights reserved.


import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    
    @State private var heliPosition = CGPoint(x: UIScreen.main.bounds.width / 3, y: UIScreen.main.bounds.height / 2)
    @State private var obstPosition = CGPoint(x:1000, y: 300)
    @State private var touchRelativePosition = CGPoint(x:0, y:0)
    @State private var position: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero
    @State private var deltaX : CGFloat = 0
    @State private var deltaY : CGFloat = 0
    @State private var isPaused = false
    @State private var backgroundColor: Color = Color.black
    @State private var score = 0
    
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        
        GeometryReader { geo in
            
        
            ZStack{

                Helicopter()
//                    .position(self.heliPosition)
                    .position(x: self.heliPosition.x + dragOffset.width, y: self.heliPosition.y + dragOffset.height)
                    .onReceive(self.timer) {_ in
                        self.gravity()
                    }
//                    .offset(x: position.width + dragOffset.width, y: position.height + dragOffset.height)
                
                Obstacle()
                    .position(self.obstPosition)
                    .onReceive(self.timer) {_ in
                        self.obstMove()
                    }
                
                Text("\(self.score)")
                    .foregroundColor(.white)
                    .position(x: geo.size.width - 100, y: geo.size.height / 10 )
                
                self.isPaused ? Button("Resume") { self.resume() } : nil

                                
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(backgroundColor)
            .gesture(
                        DragGesture()
                            .updating($dragOffset, body: { (value, dragOffset, transaction) in
                                dragOffset = value.translation
                            })
                            .onEnded { value in
                                self.heliPosition.x += value.translation.width
//                                position.width += value.translation.width
                                self.heliPosition.y += value.translation.height
//                                position.height += value.translation.height
                            }
                    )
                .onReceive(self.timer) { _ in
                    self.collisionDetection();
                    self.score += 1
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    
    func gravity() {
        withAnimation{		
            self.heliPosition.y += 0
//            self.heliPosition.y += 20
        }
    }
    
    func obstMove() {
        
        if self.obstPosition.x > 0
        {
            withAnimation{
                self.obstPosition.x -= 20
            }
        }
        else
        {
            self.obstPosition.x = 1000
            self.obstPosition.y = CGFloat.random(in: 0...500)
            
        }
    }
    
    func pause() {
        self.timer.upstream.connect().cancel()
    }
    
    func resume() {
        
        self.timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        
        self.obstPosition.x = 1000 // move obsitcle to starting position
        self.heliPosition = CGPoint(x: 100, y: 100) // helicopter to tarting position
        self.isPaused = false
        self.score = 0
        self.backgroundColor = Color.black
    }
    
    func collisionDetection() {
      
        if abs(heliPosition.x - obstPosition.x) < (25 + 10) && abs(heliPosition.y - obstPosition.y) < (25 + 100) {
            self.pause()
            self.isPaused = true
            self.backgroundColor = Color.red
        }
        
        
    }
    

    
}

