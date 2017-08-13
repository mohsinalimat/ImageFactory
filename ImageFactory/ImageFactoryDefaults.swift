//
//  ImageFactoryDefaults.swift
//  Pods
//
//  Created by Meniny on 2017-08-13.
//
//

import Foundation
import UIKit

open class ImageFactoryDefaults {
    
    open static let standard = ImageFactoryDefaults()
    
    open static let gradientLocations: [CGFloat] = [0, 1]
    open static let gradientFrom: CGPoint = .zero
    open static let gradientTo: CGPoint = CGPoint(x: 0, y: 1)
    
    open var colors: [UIColor] = [.clear]
    open var colorLocations: [CGFloat] = gradientLocations
    open var colorStartPoint: CGPoint = gradientFrom
    open var colorEndPoint: CGPoint = gradientTo
    
    open var borderColors: [UIColor] = [.black]
    open var borderColorLocations: [CGFloat] = gradientLocations
    open var borderColorStartPoint: CGPoint = gradientFrom
    open var borderColorEndPoint: CGPoint = gradientTo
    open var borderWidth: CGFloat = 0
    open var borderAlignment: CGBorderAlignment = .inside
    
    open var cornerRadius: CGCornerRadius = CGCornerRadius.zero
    
    open var size: CGSizeType = .resizable
}
