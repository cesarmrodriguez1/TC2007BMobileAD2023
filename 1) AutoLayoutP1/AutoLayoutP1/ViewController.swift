//
//  ViewController.swift
//  AutoLayoutP1
//
//  Created by César Manuel on 14/08/23.
//

import UIKit

class ViewController:
    UIViewController {
    
    
    @IBOutlet weak var label1: UILabel!
    
    
    @IBOutlet weak var label2: UILabel!
    
    
    @IBOutlet weak var label3: UILabel!
    
    
    @IBOutlet weak var button1: UIButton!
    
    
    @IBOutlet weak var button2: UIButton!
    
    
    
    @IBOutlet weak var button3: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        button1.layer.cornerRadius = 15.0
        
        button2.layer.cornerRadius = 25.0
        
        button3.layer.cornerRadius = 45.0
        
        
    }


}

