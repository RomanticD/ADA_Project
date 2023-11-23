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
    let imageRight = "Illustration 7"
    
    var body: some View {
        HStack(spacing: 0) {
            VStack{
                Spacer(minLength: 0)
                
                Image(imageLeft)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding(.top, -30)
                
                Text("Welcome to Group 2's Project")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundStyle(.primary)
                    .padding(.bottom, 30)
                
                createProfileView("Junhua Di")
                createProfileView("Yicheng Wang")
                createProfileView("Yuliang Sun")
                
                Spacer()
            }
            .frame(width: (screen!.width / 1.5) / 2)
            .background(Color(hex: "8c44f5").opacity(0.1))
            
            
            VStack{
                Spacer()
                
                Image(imageRight)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.leading, -100)
                    .padding(.trailing, 30)
                
                Spacer()
            }
            .frame(width: (screen!.width / 1.5) / 2)
            .background(Color(hex: "8c44f5").opacity(0.7))
            
        }
        .navigationTitle("Welcome")
        .ignoresSafeArea(.all, edges: .all)
//        .frame(width: (screen!.width / 1.8), height: (screen!.height / 1.8))
    }
    
    @ViewBuilder
    private func createProfileView(_ name : String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color.white)
                .frame(width: 200, height: 50)
                .shadow(color: Color.black.opacity(0.1), radius: 7, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.1), radius: 7, x: -5, y: -5)
            
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.indigo)
                
                Spacer(minLength: 0)
                
                Text(name)
                    .tracking(0.8)
                    .foregroundStyle(Color.black)
                    .bold()
                    .padding(.leading)
                
                Spacer()
            }
            .frame(width: 150)
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.white)
        }
    }
}

#Preview {
    WelcomePage()
}
