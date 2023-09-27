//
//  Menu.swift
//  MyCoffeeApp
//
//  Created by César on 13/05/21.
//

import SwiftUI

struct Menu: View {
    @ObservedObject var homeData : HomeViewModel
    
    var body: some View {
        VStack{
            NavigationLink(destination: CartView(homeData: homeData)){
                    HStack(spacing: 15){
                        Image(systemName: "cart")
                            .font(.title)
                            .foregroundColor(Color.blue)
                        
                        Text("Cart")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Spacer(minLength: 0)
                    }
                    .padding()
            }
            Spacer()
            
            HStack{
                Spacer()
                
                Text("Version 1.0")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .padding(10)
        }
        .padding([.top, .trailing])
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color.white.ignoresSafeArea())
    }
}
