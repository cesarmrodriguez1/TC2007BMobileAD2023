//
//  DetailViewController.swift
//  MyCollectionView
//
//  Created by César Manuel on 24/08/23.
//

import UIKit

class DetailViewController: UIViewController{
    
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    
    @IBOutlet weak var detailLabel: UILabel!
    
    var detailName: String?
    var detailImage: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailLabel.text = detailName
        detailImageView.downloadedFrom(from: detailImage!)
    }
    
}
