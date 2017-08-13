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
    
    public func clipEllipse(border: CGFloat = 0, color: UIColor = .clear) -> UIImage? {
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(border)
        context.setStrokeColor(color.cgColor)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.addEllipse(in: rect)
        context.clip()
        
        draw(in: rect)
        
        context.addEllipse(in: rect)
        context.strokePath()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    public func clipRect(_ rect: CGRect, border: CGFloat = 0, color: UIColor = .clear) -> UIImage? {
        guard let cg = cgImage else {
            return nil
        }
        
        guard let imageRef = cg.cropping(to: rect) else {
            return nil
        }
        
        let smallBounds = CGRect(x: 0, y: 0, width: CGFloat(imageRef.width), height: CGFloat(imageRef.height))
        
        UIGraphicsBeginImageContext(smallBounds.size)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(imageRef, in: smallBounds)
        UIGraphicsEndImageContext()
        
        return UIImage(cgImage: imageRef)
    }
    
    public func addBorder(width border: CGFloat = 0, color: UIColor = .clear) -> UIImage? {
        return clipRect(CGRect(origin: .zero, size: size), border: border, color: color)
    }
    
    public func clipRect(cornerRadius: CGCornerRadius) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        
        let path: UIBezierPath
        
        if cornerRadius.isAllEquals && cornerRadius.topLeft > 0 {
            path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius.topLeft)
            
        } else if cornerRadius.maxRadius > 0 {
            let startAngle = CGFloat.pi
            
            let topLeftCenter = CGPoint(
                x: cornerRadius.topLeft,
                y: cornerRadius.topLeft
            )
            let topRightCenter = CGPoint(
                x: size.width - cornerRadius.topRight,
                y: cornerRadius.topRight
            )
            let bottomRightCenter = CGPoint(
                x: size.width - cornerRadius.bottomRight,
                y: size.height - cornerRadius.bottomRight
            )
            let bottomLeftCenter = CGPoint(
                x: cornerRadius.bottomLeft,
                y: size.height - cornerRadius.bottomLeft
            )
            
            let strokePath = UIBezierPath()
            
            // top left
            if cornerRadius.topLeft > 0 {
                strokePath.addArc(withCenter: topLeftCenter,
                                  radius: cornerRadius.topLeft,
                                  startAngle: startAngle,
                                  endAngle: 1.5 * startAngle,
                                  clockwise: true)
            } else {
                strokePath.move(to: topLeftCenter)
            }
            
            // top right
            if cornerRadius.topRight > 0 {
                strokePath.addArc(withCenter: topRightCenter,
                                  radius: cornerRadius.topRight,
                                  startAngle: 1.5 * startAngle,
                                  endAngle: 2 * startAngle,
                                  clockwise: true)
            } else {
                strokePath.addLine(to: topRightCenter)
            }
            
            // bottom right
            if cornerRadius.bottomRight > 0 {
                strokePath.addArc(withCenter: bottomRightCenter,
                                  radius: cornerRadius.bottomRight,
                                  startAngle: 2 * startAngle,
                                  endAngle: 2.5 * startAngle,
                                  clockwise: true)
            } else {
                strokePath.addLine(to: bottomRightCenter)
            }
            
            // bottom left
            if cornerRadius.bottomLeft > 0 {
                strokePath.addArc(withCenter: bottomLeftCenter,
                                  radius: cornerRadius.bottomLeft,
                                  startAngle: 2.5 * startAngle,
                                  endAngle: 3 * startAngle,
                                  clockwise: true)
            } else {
                strokePath.addLine(to: bottomLeftCenter)
            }
            
            if cornerRadius.topLeft > 0 {
                strokePath.addLine(to: CGPoint(x: 0, y: topLeftCenter.y))
            } else {
                strokePath.addLine(to: topLeftCenter)
            }
            
            path = strokePath
            
        } else {
            path = UIBezierPath(rect: rect)
        }
        
        context?.addPath(path.cgPath)
        context?.clip()
        
        draw(in: rect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    public func scale(to scale: CGSize, border: CGFloat = 0, color: UIColor = .clear) -> UIImage? {
        UIGraphicsBeginImageContext(scale);
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(border)
        context?.setStrokeColor(color.cgColor)
        let rect = CGRect(origin: .zero, size: scale)
        context?.addRect(rect)
        context?.clip()
        
        draw(in: rect)
        
        context?.addRect(rect)
        context?.strokePath()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

