//
//  CustomDialog.swift
//  FavPlacesApp
//
//  Created by Hugo López on 18-06-24.
//

import SwiftUI

struct CustomDialog<Content: View>: View {
    
    let closeDialog:() -> Void
    let onDismissOutside:Bool
    let content:Content
    
    var body: some View {
        ZStack{
            Rectangle().fill(.white.opacity(0.5))
                .ignoresSafeArea()
                .blur(radius: 3)
                .onTapGesture {
                    if onDismissOutside {
                        closeDialog()
                    }
                }
            content
                .frame(width: UIScreen.main.bounds.width-100, height: 300)
                .padding()
                .background(.white)
                .cornerRadius(16)
                .overlay(alignment: .topTrailing) {
                    Button(action: {
                        withAnimation{
                            closeDialog()
                        }
                    }, label: {
                        Image(systemName: "xmark.circle")
                    }).foregroundColor(.gray).padding()
                }
        }.ignoresSafeArea()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
            
    }
}
