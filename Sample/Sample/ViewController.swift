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

    var factoryArray: [ImageFactory] = []
    
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
        factoryArray.removeAll()
        
        let sizeType = CGSizeType.fixed(size)
        
        factoryArray += ImageFactory(fillColor: .brown)
        factoryArray += ImageFactory(fillGradient: [.red, .green])
        
        factoryArray += ImageFactory(borderColor: .red, width: 10, size: sizeType)
        factoryArray += ImageFactory(border: .yellow, width: 10, background: .green, size: sizeType)
        factoryArray += ImageFactory(borderGradient: [.green, .yellow, .red], width: 10, size: sizeType)
        factoryArray += ImageFactory(border: .red, width: 10, alignment: .inside, background: .purple, size: sizeType, cornerRadius: CGCornerRadius(.all, radius: 15))
    }
}

public func += (lhs: inout [ImageFactory], rhs: ImageFactory) {
    lhs.append(rhs)
}

extension ViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as! ImageTableViewCell
        let factory = factoryArray[indexPath.row]
        cell.centerImageView.image = factory.image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return size.width
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return factoryArray.count
    }
}

