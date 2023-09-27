//
//  CartView.swift
//  MyCoffeeApp
//
//  Created by César on 18/05/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    @ObservedObject var homeData: HomeViewModel
    @Environment(\.presentationMode) var present
    
    
    var body: some View {
        VStack{
            Spacer()
            HStack(spacing: 20){
                Button(action: {present.wrappedValue.dismiss()}){
                    Image(systemName: "chevron.left")
                        .font(.system(size: 25, weight: .heavy))
                        .foregroundColor(.black)
                }
                
            Text("Your order")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.black)

            }
            .padding()
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(spacing: 0){
                    Text(homeData.cartItems.count > 0 ? "Your selected meals:" : "Your haven't selected meals for your order")
                    
                    ForEach(homeData.cartItems){ cart in
                        HStack(spacing: 15){
                            WebImage(url: URL(string: cart.item.item_image))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 130)
                                .cornerRadius(15)
                            
                            VStack(alignment: .leading, spacing: 30){
                                Text(String(cart.item.item_name))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                
                                HStack(spacing: 15){
                                    Text(homeData.getPrice(value: Double(truncating: cart.item.item_cost)))
                                        .foregroundColor(.black)
                                    
                                    Spacer(minLength: 0)
                                    
                                    //Add - Sub Button
                                    
                                    Button(action: {
                                        if cart.quantity > 1 {
                                            homeData.cartItems[homeData.getCartIndex(cart: cart)].quantity -= 1
                                        }
                                    }){
                                        Image(systemName: "minus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                    
                                    Text("\(cart.quantity)")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                        .background(Color.black.opacity(0.06))
                                    
                                    Button(action: {
                                        homeData.cartItems[homeData.getCartIndex(cart: cart)].quantity+=1
                                        
                                        
                                    }){
                                        Image(systemName: "plus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                    Button(action: {
                                        let index = homeData.getCartIndex(cart: cart)
                                        let itemIndex = homeData.getCartIndex(cart: cart)
                                        
                                        let filterIndex = homeData.filtered.firstIndex{ (item1) -> Bool in
                                            return cart.item.id == item1.id
                                        } ?? 0
                                        
                                        homeData.items[itemIndex].isAdded = false
                                        homeData.filtered[filterIndex].isAdded = false
                                        
                                        homeData.cartItems.remove(at: index)
                                        
                                    }){
                                        Image(systemName: "trash")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        .padding()
                        .contentShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
            }
            
            VStack{
                HStack{
                    Text("Total")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(homeData.calculateTotalPrice())
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
                .padding([.top, .horizontal])
                
                Button(action: homeData.updateOrder){
                    Text(homeData.ordered ? "Cancel order" : "Check out")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(
                            LinearGradient(gradient: .init(colors: [Color.blue, Color.blue]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(15)
                }
            }
            .background(Color.white)
            
          //  Spacer(minLength: 0)
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }
}

