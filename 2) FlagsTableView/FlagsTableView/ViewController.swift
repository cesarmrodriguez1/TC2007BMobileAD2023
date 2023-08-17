//
//  ViewController.swift
//  FlagsTableView
//
//  Created by César Manuel on 14/08/23.
//

import UIKit
import SVGKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var countries: [Nation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://cdn.jsdelivr.net/npm/country-flag-emoji-json@2.0.0/dist/index.json")
        
        //Communicate with API
        
        let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
            
            if error != nil{
                print(error!)
            }
            else{
                if let urlContent = data{
                    do{
                        let nations = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        for i in 0...nations.count - 1{
                            
                            let dictionary = nations.object(at: i) as! NSDictionary
                            
                            //Country temporal:
                            
                            let mycountry = Nation(country: (dictionary["name"] ?? "No country available") as! String, flag: (dictionary["image"] ?? "No image available") as! String, code: (dictionary["code"] ?? "No code available") as! String)
                            
                            self.countries.append(mycountry)
                        }
                    }
                    catch{
                        print("JSON cannot be obtained")
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "mycell")
        
        cell.textLabel?.text = countries[indexPath.row].country
        
        let flag = SVGKImage(contentsOf: URL(string: countries[indexPath.row].flag)!)
        
        cell.imageView!.image = flag!.uiImage
        
        return cell
        
    }
}

