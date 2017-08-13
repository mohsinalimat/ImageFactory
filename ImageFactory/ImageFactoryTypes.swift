//
//  ImageFactoryTypes.swift
//  Pods
//
//  Created by Meniny on 2017-08-13.
//
//

import Foundation
import UIKit

public enum CGBorderAlignment {
    case inside
    case center
    case outside
}

public enum CGSizeType {
    case fixed(CGSize)
    case resizable
}

public struct CGCornerRadius {
    
    public var topLeft: CGFloat = 0
    public var topRight: CGFloat = 0
    public var bottomLeft: CGFloat = 0
    public var bottomRight: CGFloat = 0
    
    public init() {}
    
    public init(radius cornerRadius: CGFloat) {
        topLeft = cornerRadius
        topRight = cornerRadius
        bottomLeft = cornerRadius
        bottomRight = cornerRadius
    }
    
    public init(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
}

public enum CGCornerType {
    case topLeft, topRight, bottomLeft, bottomRight, all
}

extension CGCornerRadius {
    
    public static var zero: CGCornerRadius {
        return CGCornerRadius()
    }
    
    public var isAllEquals: Bool {
        return topLeft == topRight &&
            topLeft == bottomLeft &&
            topLeft == bottomRight
    }
    
    public var maxRadius: CGFloat {
        let m = max(topLeft, topRight, bottomLeft, bottomRight)
        return m > 0 ? m : 0
    }
    
    public init(_ corner: CGCornerType, radius cornerRadius: CGFloat) {
        switch corner {
        case .topLeft:
            topLeft = cornerRadius
            break
        case .topRight:
            topRight = cornerRadius
            break
        case .bottomLeft:
            bottomLeft = cornerRadius
            break
        case .bottomRight:
            bottomRight = cornerRadius
            break
        default:
            topLeft = cornerRadius
            topRight = cornerRadius
            bottomLeft = cornerRadius
            bottomRight = cornerRadius
            break
        }
    }
    
    public init(topLeft: Int, topRight: Int, bottomLeft: Int, bottomRight: Int) {
        self.init(topLeft: CGFloat(topLeft),
                  topRight: CGFloat(topRight),
                  bottomLeft: CGFloat(bottomLeft),
                  bottomRight: CGFloat(bottomRight))
    }
    
    public init(topLeft: Double, topRight: Double, bottomLeft: Double, bottomRight: Double) {
        self.init(topLeft: Double(topLeft),
                  topRight: Double(topRight),
                  bottomLeft: Double(bottomLeft),
                  bottomRight: Double(bottomRight))
    }
    
    public init(_ topLeft: CGFloat, _ topRight: CGFloat, _ bottomLeft: CGFloat, _ bottomRight: CGFloat) {
        self.init(topLeft: topLeft,
                  topRight: topRight,
                  bottomLeft: bottomLeft,
                  bottomRight: bottomRight)
    }
}

public typealias CGContextClosure = (CGContext) -> Void
