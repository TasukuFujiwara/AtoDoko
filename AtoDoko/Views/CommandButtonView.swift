//
//  CommandButtonView.swift
//  AtoDoko
//
//  Created by 藤原輔 on 2023/06/17.
//

import SwiftUI

struct CommandButtonView: View {
    @State private var onMenu = true
    @State private var text = ""
    @State private var leftMode = false
    
    var body: some View {
        ZStack {
            Color.teal
                .ignoresSafeArea()
            
            ZStack {
                TextField("検索", text: $text)
                    .padding()
                    .textInputAutocapitalization(.never)
                    .background(.white)
                    .cornerRadius(40.0)
                    .padding(.horizontal, 60)
                    .offset(
                        x: !onMenu ? 0 : !leftMode ? -30.0 : 30.0,
                        y: !onMenu ? 0 : -60.0
                    )
                    .scaleEffect(!onMenu ? 0 : 1.0, anchor: !leftMode ? .bottomTrailing : .bottomLeading)
                
                HStack {
                    if !leftMode {
                        Spacer()
                    }
                    ZStack {
                        Button(action: {
                            leftMode.toggle()
                        }, label: {
                            Image(systemName: !leftMode ? "circle.lefthalf.fill" : "circle.righthalf.fill")
                                .font(.system(size: 80.0))
                        })
                        .offset(
                            x: !onMenu ? 0 : !leftMode ? -100.0 : 100.0,
                            y: !onMenu ? 0 : 70.0
                        )
                        .scaleEffect(!onMenu ? 0 : 1.0, anchor: !leftMode ? .topTrailing : .topLeading)
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                onMenu.toggle()
                            }
                        }, label: {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.system(size: 80.0))
                        })
                    }
                    if leftMode {
                        Spacer()
                    }
                }
            }
        }
    }
}

struct CommandButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CommandButtonView()
    }
}
