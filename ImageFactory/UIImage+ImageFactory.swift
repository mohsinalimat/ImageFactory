//
//  UIImage+ImageFactory.swift
//  
//
//  Created by Meniny on 2017-08-13.
//
//

import Foundation
import UIKit

public func + (lhs: UIImage, rhs: UIImage) -> UIImage? {
    return UIImage.draw(image: lhs, on: rhs)
}

public extension UIImage {
    
    public class func draw(width: CGFloat, height: CGFloat, handler: CGContextClosure) -> UIImage? {
        return self.draw(size: CGSize(width: width, height: height), handler: handler)
    }
    
    public class func draw(size: CGSize, opaque: Bool = false, scale: CGFloat = 0, handler: CGContextClosure) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()!
        handler(context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func draw(_ handler: CGContextClosure) -> UIImage? {
        return UIImage.draw(size: self.size, opaque: false, scale: self.scale) { context in
            let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            self.draw(in: rect)
            handler(context)
        }
    }
    
    public func draw(color: UIColor) -> UIImage? {
        return UIImage.draw(size: self.size) { context in
            context.translateBy(x: 0, y: self.size.height)
            context.scaleBy(x: 1, y: -1)
            context.setBlendMode(.normal)
            let rect = CGRect(origin: .zero, size: self.size)
            guard let cg = self.cgImage else {
                color.setFill()
                context.fill(rect)
                print("[ImageFactory] Found nil when calling CGImage")
                return
            }
            context.clip(to: rect, mask: cg)
            color.setFill()
            context.fill(rect)
        }
    }
    
    public func draw(at image: UIImage) -> UIImage? {
        return UIImage.draw(image: self, on: image)
    }
    
    public class func draw(image lhs: UIImage, on rhs: UIImage) -> UIImage? {
        return lhs.draw { context in
            let lhsRect = CGRect(x: 0, y: 0, width: lhs.size.width, height: lhs.size.height)
            var rhsRect = CGRect(x: 0, y: 0, width: rhs.size.width, height: rhs.size.height)
            
            if lhsRect.contains(rhsRect) {
                rhsRect.origin.x = (lhsRect.size.width - rhsRect.size.width) / 2
                rhsRect.origin.y = (lhsRect.size.height - rhsRect.size.height) / 2
            } else {
                rhsRect.size = lhsRect.size
            }
            
            lhs.draw(in: lhsRect)
            rhs.draw(in: rhsRect)
        }
    }
    
}

public extension UIImage {
    
    public class func fixedFactory(width: CGFloat, height: CGFloat) -> ImageFactory {
        return fixedFactory(size: CGSize(width: width, height: height))
    }
    
    public class func fixedFactory(size: CGSize) -> ImageFactory {
        let factory = ImageFactory()
        factory.configuration.size = .fixed(size)
        return factory
    }
    
    public class func resizableFactory() -> ImageFactory {
        let factory = ImageFactory()
        factory.configuration.size = .resizable
        return factory
    }
}
