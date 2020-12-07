//
//  TopCollectionViewCell.swift
//  FORSA
//
//  Created by apple on 17/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var typeCollectionView: UICollectionView!
    var index = 0
    
    let typeTuple = [("Property","building", UIColor(red: 95/255, green: 103/255, blue: 236/255, alpha: 1.0)),("Cars","car", UIColor(red: 255/255, green: 112/255, blue: 67/255, alpha: 1.0)),("Bikes","motorcycle", UIColor(red: 248/255, green: 169/255, blue: 68/255, alpha: 1.0)),("More","circle", UIColor(red: 16/255, green: 166/255, blue: 249/255, alpha: 1.0))]
    
    override func awakeFromNib() {
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
    }
    
    func setUpCollection(indexPath : Int) {
        index = indexPath
    }
    
}


extension TopCollectionViewCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.typeTuple.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if index == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCollectionViewCell", for: indexPath) as! TypeCollectionViewCell
            cell.imgType.backgroundColor = typeTuple[indexPath.item].2
            cell.imgType.image = UIImage(named: typeTuple[indexPath.item].1)
            cell.lblName.text = typeTuple[indexPath.item].0
            cell.imgType.contentMode = .center
            cell.layer.cornerRadius = 4
        return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeSecondCollectionViewCell", for: indexPath) as! TypeCollectionViewCell
                   return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if index == 0 {
            return CGSize(width: (UIScreen.main.bounds.width - 40)/4, height: 100)
        } else {
            return CGSize(width: (UIScreen.main.bounds.width)/2 - 10, height: 240)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if index == 0 {
        return 2
        } else {
            return 15
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         if index == 0 {
               return 2
               } else {
                   return 15
                   
               }
    }
    
}
