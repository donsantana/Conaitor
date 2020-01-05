//
//  MenuCollectionViewCell.swift
//  MovilClub
//
//  Created by Donelkys Santana on 5/25/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit


class MenuCollectionViewCell: UICollectionViewCell{
  
  @IBOutlet weak var transporteImage: UIImageView!
  
  func initContent(transporteImageName: String){
    transporteImage.image = UIImage(named: transporteImageName)
  }
  
}
