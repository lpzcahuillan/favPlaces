//
//  ContentView.swift
//  FavPlacesApp
//
//  Created by Hugo López on 16-06-24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var isPresented: Bool = false
    var body: some View {
        ZStack {
            Map()
            VStack{
                Spacer()
                VStack{
                    Button(action: {isPresented = true}, label: {
                        Text("Lugares Favoritos")
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: 80)
                            .background(.white)
                            .cornerRadius(16)
                            .padding()
                    })
                }
            }
        }.sheet(isPresented: $isPresented, onDismiss: { isPresented = false}) {
            ZStack{
                Text("hola")
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .blur(radius: 5)
    }
}

#Preview {
    ContentView()
}
