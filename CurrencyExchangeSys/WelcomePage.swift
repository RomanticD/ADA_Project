//
//  WelcomePage.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/18.
//

import SwiftUI

struct WelcomePage: View {
    var screen = NSScreen.main?.visibleFrame
    let imageLeft = "Illustration 9"
    let imageRight = "Illustration 5"
    
    var body: some View {
        HStack(spacing: 0) {
            
            VStack{
                Spacer(minLength: 0)
                
                Image(imageLeft)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                
                Text("Welcome to Group 2's Project")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundStyle(.black)
                    .padding(.bottom, 30)
                
                createProfileView("Junhua Di")
                createProfileView("Yicheng Wang")
                createProfileView("Yuliang Sun")
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            
            
            VStack{
                Spacer()
                
                Image(imageRight)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.leading, -35)
                
                Spacer()
            }
            .frame(width: (screen!.width / 1.8) / 2)
            .background(Color(hex: "8c44f5"))
        }
        .navigationTitle("Welcome")
        .ignoresSafeArea(.all, edges: .all)
        .frame(width: (screen!.width / 1.8), height: (screen!.height / 1.8))
    }
    
    @ViewBuilder
    func createProfileView(_ name : String) -> some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(.indigo)
            
            Spacer(minLength: 0)
            
            Text(name)
                .padding(.leading)
        }
        .frame(width: 150)
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
    }
}

#Preview {
    WelcomePage()
}
