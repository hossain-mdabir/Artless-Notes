//
//  ToastTest.swift
//  THP Online
//
//  Created by AM1 on 23/10/22.
//

import SwiftUI

// MARK: - Toast for Order
struct ToastNotification: ViewModifier {
    
    @Binding var isToast: Bool
    @Binding var msg: String
    
    let duration: TimeInterval
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isToast {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "pencil.and.outline")
                        
                        Text(msg)
                            .font(.footnote)
                    }
                    .scaledToFit()
                    .padding(10)
                    .foregroundColor(Color("ButtonFor"))
                    .background(Color("Toast"))
                    .shadow(color: .gray, radius: 2, x: 0, y: 3)
                    .cornerRadius(5)
                }
                .padding(.bottom, 80)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isToast = false
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Order Toast Duration Extension
extension View {
    func toastNotification(isToast: Binding<Bool>, msg: Binding<String>, duration: TimeInterval = 3) -> some View {
        modifier(ToastNotification(isToast: isToast, msg: msg, duration: duration))
    }
}
