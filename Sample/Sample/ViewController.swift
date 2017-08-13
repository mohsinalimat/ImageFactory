//
//  ViewController.swift
//  Sample
//
//  Created by Meniny on 2017-08-13.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import UIKit
import ImageFactory

class ViewController: UITableViewController {

    var images: [UIImage?] = []
    
    let size = CGSize(width: 100, height: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let nib = UINib(nibName: "ImageTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ImageTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        prepareDataSource()
    }
    
    func prepareDataSource() {
        images.removeAll()
        
        let sizeType = CGSizeType.fixed(size)
        
        images += ImageFactory(fillColor: .brown)
        images += ImageFactory(fillGradient: [.red, .green])
        images += ImageFactory(borderColor: .red, width: 10, size: sizeType)
        images += ImageFactory(border: .yellow, width: 10, background: .green, size: sizeType)
        images += ImageFactory(borderGradient: [.green, .yellow, .red], width: 10, size: sizeType)
        images += ImageFactory(border: .red, width: 10, alignment: .inside, background: .purple, size: sizeType, cornerRadius: CGCornerRadius(.all, radius: 15))
        
        let finder = #imageLiteral(resourceName: "finder")
        
        images += ImageFactory.clipEllipse(image: finder)
        images += ImageFactory.clipRect(image: finder, rect: CGRect(x: 10, y: 10, width: 30, height: 30))
        images += ImageFactory.scale(image: finder, to: size / 10)
        images += ImageFactory.clipRect(image: finder, cornerRadius: CGCornerRadius(.all, radius: 50))
    }
}

public func += (lhs: inout [UIImage?], rhs: ImageFactory) {
    lhs.append(rhs.image)
}

public func += (lhs: inout [UIImage?], rhs: UIImage?) {
    lhs.append(rhs)
}

public func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
}

extension ViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as! ImageTableViewCell
        cell.centerImageView.image = images[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return size.width
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
}

