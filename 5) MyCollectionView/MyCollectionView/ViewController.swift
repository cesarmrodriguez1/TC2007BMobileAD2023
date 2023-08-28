//
//  ViewController.swift
//  MyCollectionView
//
//  Created by César Manuel on 21/08/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var FruitCollectionView: UICollectionView!
    
    var myfruits: [Fruit] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Getting data from JSON:
        
        if let url = URL(string: "https://gist.githubusercontent.com/amlcurran/6d174c472e2523be5f9cad7092e1d7ab/raw/edfb73c8ade674f40bfff8f3dfed97d327c1abc1/fruits.json"){
            
            URLSession.shared.dataTask(with: url){ (data, response, error) in
                
                if let obtained = data{
                    
                    do{
                        let results = try JSONDecoder().decode(Fruits.self, from: obtained)
                        
                        for result in results.fruits{
                            self.myfruits.append(Fruit(name: result.name, image: result.image, price: result.price))
                            
                            print(result.image)
                        }
                    
                    }
                    catch let error{
                        print(error)
                    }
                    DispatchQueue.main.async{
                        self.FruitCollectionView.reloadData()
                    }
                }
            }
            .resume()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myfruits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "Item"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! FruitCollectionViewCell
        
        cell.fruitLabel.text = self.myfruits[indexPath.row].name
        cell.fruitImageView.downloadedFrom(from: self.myfruits[indexPath.row].image)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let item = sender as? UICollectionViewCell
        
        let indexPath = FruitCollectionView.indexPath(for: item!)
        
        let detailVC = segue.destination as! DetailViewController
        
        detailVC.detailName = myfruits[(indexPath?.row)!].name
        detailVC.detailImage = myfruits[(indexPath?.row)!].image
    }
    
}

extension UIImageView{
    //Code to download jpg image to Image View
    
    func downloadedFrom(from url: URL, contentMode mode: ContentMode = .scaleAspectFit){
        URLSession.shared.dataTask(with: url){ data, response, error in
            
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else{
                return
            }
                
            DispatchQueue.main.async{ [weak self] in
                self?.image = image
                
            }
        }
        .resume()
    }
    
    func downloadedFrom(from link: String, contentMode mode: ContentMode = .scaleAspectFill){
        guard let url = URL(string: link) else{ return}
        
        downloadedFrom(from: url, contentMode: mode)
    }
}

