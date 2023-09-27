//
//  HomeViewModel.swift
//  MyCoffeeApp
//
//  Created by César on 13/05/21.
//

import SwiftUI
import CoreLocation
import Firebase

class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
   
    //Set attributes
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    
    @Published var userLocation: CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false
    
    //Menu
    @Published var showMenu = false
    
    //Items obtained in Firebase
    
    @Published var items: [Item] = []
    @Published var filtered: [Item] = []
    
    //Cart Data...
    
    @Published var cartItems: [Cart] = []
    @Published var ordered = false
    
    
    //Verify if user authorized location
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
        //Check location address
        
        switch manager.authorizationStatus{
        case .authorizedWhenInUse:
            print("User just authorized location")
            self.noLocation = false
            manager.requestLocation()
        case .denied:
            print("User denied")
            self.noLocation = true
        default:
            print("App doesn't know about permission")
            self.noLocation = false
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error.localizedDescription)
    }
    
    //Added:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        self.userLocation = locations.last
        self.extractLocation()
        
        //Once we have the location we can login to Firebase
        
        self.login()
    }
    
    func extractLocation(){
        CLGeocoder().reverseGeocodeLocation(self.userLocation){ (result, error) in
            guard let safeData = result else{return}
            
            var address = ""
            
            //Get area of locality
            
            address += safeData.first?.name ?? ""
            address += ","
            address += safeData.first?.locality ?? ""
            
            self.userAddress = address
        }
    }
    
    //Login for Reading Firebase Database
    
    func login(){
        Auth.auth().signInAnonymously{ (result, error) in
            
            if error != nil{
                print("Login error: \(error.debugDescription)")
                print(error!.localizedDescription)
                return
            }
            print("Success!!! :D. Connection reference: \(String(describing:result?.user.uid))")
            
            //Once we get here, we can fetch data from Firebase!!! :D
            
            self.fetchData()
        }
    }
    
    //Fetching data
    
    func fetchData(){
        let db = Firestore.firestore()
        
        db.collection("Meals").getDocuments{ (snap, error) in
            guard let itemData = snap else{ return}
            
            self.items = itemData.documents.compactMap({ (doc) -> Item? in
                
                let id = doc.documentID
                let name = doc.get("meal_name") as! String
                let cost = doc.get("meal_cost") as! NSNumber
                let ratings = doc.get("meal_rating") as! String
                let image = doc.get("meal_image") as! String
                let details = doc.get("meal_details") as! String
                
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_ratings: ratings, item_quantity: 1, isAdded: false)
            })
            self.filtered = self.items
        }
    }
    
    func filterData(){
        withAnimation(.linear){
            self.filtered = self.items.filter{
                return $0.item_name.lowercased().contains(self.search.lowercased())
            }
        }
    }
    
    func addToCart(item: Item, cart: Cart){
        self.items[getItemIndex(item: item)].isAdded = !item.isAdded
        
        let filterIndex = self.filtered.firstIndex{ (item1) -> Bool in
            return item.id == item1.id
        } ?? 0
        
        self.filtered[filterIndex].isAdded = !item.isAdded
        
        if item.isAdded{
            self.cartItems.remove(at: getCartIndex(cart: cart))
            return
        }
        self.cartItems.append(cart)
    }
    
    func getItemIndex(item: Item) -> Int{
        let index = self.items.firstIndex{ (item1) -> Bool in
            
            return item.id == item1.id
            
        } ?? 0

        return index
    }
    
    func getCartIndex(cart: Cart) -> Int{
        
        let index = self.cartItems.firstIndex{ (cart1) -> Bool in
            
                return cart.id == cart1.id
        } ?? 0
       return index
    }
    
    func calculateTotalPrice()->String{
        var price : Double = 0
        
        cartItems.forEach{ (item) in
            price += Double(Double(truncating: NSNumber(value: item.quantity)) * Double(truncating: item.item.item_cost))
            
        }
        return getPrice(value: price)
    }
    
    func getPrice(value: Double) ->String{
        let format = NumberFormatter()
        format.numberStyle = .currency
        
        return format.string(from: NSNumber(value: value)) ?? ""
        
    }
    
    func updateOrder(){
        let db = Firestore.firestore()
        
        if ordered{
            ordered = false
            
            db.collection("Orders").document(Auth.auth().currentUser!.uid).delete{ (err) in
                if err != nil{
                    self.ordered = true
                }
            }
            return
        }
        var details : [[String : Any]] = []
        
        cartItems.forEach{ (cart) in
            
            details.append([
                "item_name": cart.item.item_name,
                "item_quantity": cart.quantity,
                "item_cost": cart.item.item_cost
            ])
        }
        ordered = true
        
        db.collection("Orders").document(Auth.auth().currentUser!.uid).setData([
            "ordered_food": details,
            "total_cost": calculateTotalPrice(),
            "location": GeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        ]) { (err) in
            if err != nil{
                self.ordered = false
                return
            }
            print("Success!! Order was uploaded")
        }
    }
}
