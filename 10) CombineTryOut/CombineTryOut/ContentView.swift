//
//  ContentView.swift
//  CombineTryOut
//
//  Created by César Manuel on 02/10/23.
//

import SwiftUI
import Combine

//MVVM

//Model:

struct User: Identifiable, Hashable, Decodable{
    let id: Int
    let name: String
}

//ViewModel:

final class ViewModel: ObservableObject{
    
    //Time from the system
    @Published var time = ""
    
    //Management of cancellables of suscriptions
    private var cancellables = Set<AnyCancellable>()
    
    
    //An array of users
    @Published var users = [User]()
    
    let formatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .medium
        return df
    }()
    
    init(){
        setupPublishers()
    }
    private func setupPublishers(){
        //setupTimer, publisher is local
        setupTimer()
        
        //setupDataTaskPublisher, publisher is an API
        setupDataTaskPublisher()
    }
    //Publisher is remote:
    
    private func setupDataTaskPublisher(){
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        
        //We start to communicate with the API:
        
        //Publisher:
        URLSession.shared.dataTaskPublisher(for: url).tryMap{ (data, response) in
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                throw URLError(.badServerResponse)
            }
            
            return data
        }
        //Subscribers:
        
        .decode(type: [User].self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .sink( receiveCompletion: {_ in }){ users in
            self.users = users
          }
        .store(in: &cancellables)
    }
    
    private func setupTimer(){
        //Publisher:
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            //subscribers:
            .receive(on: RunLoop.main)
            .sink{ value in
                self.time = self.formatter.string(from: value)
            }
            .store(in: &cancellables)
    }
}

//View:

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.time)
                .padding()
            
            List(viewModel.users, id:\.self){ user in
                
                Text(user.name)
                
            }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
