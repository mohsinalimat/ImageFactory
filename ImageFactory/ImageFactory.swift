//
//  ImageFactory.swift
//  ImageFactory
//
//  Created by Meniny on 7/14/15.
//  Copyright (c) 2015 Meniny. All rights reserved.
//

import Foundation
import UIKit

open class ImageFactory {
    
    /// Singleton `ImageFactory` instance with default configuration
    open static let `default` = ImageFactory()
    /// Defalut configuration
    open private(set) var configuration = ImageFactoryDefaults()
    
    /// ImageFactory with default configuration
    ///
    /// - Parameter config: `ImageFactory` instance
    public init() {}
    
    /// ImageFactory with specific configuration
    ///
    /// - Parameter config: `ImageFactory` instance
    public init(configuration config: ImageFactoryDefaults) {
        configuration = config
    }
    
    // MARK: Fill
    
    public convenience init(fillColor: UIColor,
                            size: CGSizeType = .resizable,
                            cornerRadius: CGCornerRadius = .zero) {
        self.init()
        configuration.colors = [fillColor]
        configuration.size = size
        configuration.cornerRadius = cornerRadius
    }
    
    public convenience init(fillGradient: [UIColor],
                            size: CGSizeType = .resizable,
                            cornerRadius: CGCornerRadius = .zero,
                            locations: [CGFloat] = ImageFactoryDefaults.gradientLocations,
                            from startPoint: CGPoint = ImageFactoryDefaults.gradientFrom,
                            to endPoint: CGPoint = ImageFactoryDefaults.gradientTo) {
        self.init()
        configuration.colors = fillGradient
        configuration.size = size
        configuration.cornerRadius = cornerRadius
        configuration.colorLocations = locations
        configuration.colorStartPoint = startPoint
        configuration.colorEndPoint = endPoint
    }
    
    // MARK: Border
    
    public convenience init(borderColor: UIColor,
                            width: CGFloat,
                            alignment: CGBorderAlignment = .inside,
                            size: CGSizeType,
                            cornerRadius: CGCornerRadius = .zero) {
        self.init()
        configuration.borderColors = [borderColor]
        configuration.borderWidth = width
        configuration.borderAlignment = alignment
        configuration.size = size
        configuration.cornerRadius = cornerRadius
    }
    
    public convenience init(borderGradient: [UIColor],
                            width: CGFloat,
                            alignment: CGBorderAlignment = .inside,
//                            background fill: UIColor,
                            size: CGSizeType,
                            cornerRadius: CGCornerRadius = .zero,
                            locations: [CGFloat] = ImageFactoryDefaults.gradientLocations,
                            from startPoint: CGPoint = ImageFactoryDefaults.gradientFrom,
                            to endPoint: CGPoint = ImageFactoryDefaults.gradientTo) {
        self.init()
        configuration.borderColors = borderGradient
//        configuration.colors = [fill]
        configuration.size = size
        configuration.cornerRadius = cornerRadius
        configuration.borderWidth = width
        configuration.borderColorLocations = locations
        configuration.borderColorStartPoint = startPoint
        configuration.borderColorEndPoint = endPoint
        configuration.borderAlignment = alignment
    }
    
    /*
    public convenience init(borderColor: UIColor,
                            width: CGFloat,
                            alignment: CGBorderAlignment = .inside,
                            fillGradient: [UIColor],
                            size: CGSizeType = .resizable,
                            cornerRadius: CGCornerRadius = .zero,
                            locations: [CGFloat] = ImageFactoryDefaults.gradientLocations,
                            from startPoint: CGPoint = ImageFactoryDefaults.gradientFrom,
                            to endPoint: CGPoint = ImageFactoryDefaults.gradientTo) {
        self.init()
        configuration.borderColors = [borderColor]
        configuration.borderWidth = width
        configuration.borderAlignment = alignment
        configuration.colors = fillGradient
        configuration.size = size
        configuration.cornerRadius = cornerRadius
        configuration.colorLocations = locations
        configuration.colorStartPoint = startPoint
        configuration.colorEndPoint = endPoint
    }
    */
    
    // MARK: Mix
    
    public convenience init(border: UIColor,
                            width: CGFloat,
                            alignment: CGBorderAlignment = .inside,
                            background fill: UIColor,
                            size: CGSizeType,
                            cornerRadius: CGCornerRadius = .zero) {
        self.init()
        configuration.borderColors = [border]
        configuration.borderWidth = width
        configuration.borderAlignment = alignment
        configuration.colors = [fill]
        configuration.size = size
        configuration.cornerRadius = cornerRadius
    }
    
    /*
    public convenience init(border: [UIColor],
                            width: CGFloat,
                            alignment: CGBorderAlignment,
                            background fill: [UIColor],
                            size: CGSizeType,
                            cornerRadius: CGCornerRadius,
                            fillLocations: [CGFloat],
                            from fillGradientStartPoint: CGPoint,
                            to fillGradientEndPoint: CGPoint,
                            borderLocations: [CGFloat],
                            from borderGradientStartPoint: CGPoint,
                            to borderGradientEndPoint: CGPoint) {
        self.init()
        configuration.colors = fill
        configuration.borderColors = border
        configuration.size = size
        configuration.cornerRadius = cornerRadius
        configuration.borderWidth = width
        
        configuration.colorLocations = fillLocations
        configuration.colorStartPoint = fillGradientStartPoint
        configuration.colorEndPoint = fillGradientEndPoint
        
        configuration.borderAlignment = alignment
        configuration.borderColorLocations = borderLocations
        configuration.borderColorStartPoint = borderGradientStartPoint
        configuration.borderColorEndPoint = borderGradientEndPoint
    }
    */
}

public extension ImageFactory {
    
    public var isAllCornerRadiusEquals: Bool {
        return configuration.cornerRadius.isAllEquals
    }
    
    public var maxCornerRadius: CGFloat {
        return configuration.cornerRadius.maxRadius
    }
    
    public func fixedImage(size s: CGSize) -> UIImage? {
        return make(size: s)
    }
    
    public var resizableImage: UIImage? {
        configuration.borderAlignment = .inside
        
        let cornerRadius = maxCornerRadius
        
        let capSize = ceil(max(cornerRadius, configuration.borderWidth))
        let imageSize = capSize * 2 + 1
        
        let image = make(size: CGSize(width: imageSize, height: imageSize))
        let capInsets = UIEdgeInsets(top: capSize, left: capSize, bottom: capSize, right: capSize)
        return image?.resizableImage(withCapInsets: capInsets)
    }
    
    // public var image: (_ sizeType: CGSizeType) -> UIImage? {
    public var image: UIImage? {
        switch configuration.size {
        case .fixed(let s):
            return fixedImage(size: s)
        default:
            return resizableImage
        }
    }
    
    public func make(size: CGSize) -> UIImage? {
        let borderWidth = configuration.borderWidth
        let hasBorder = configuration.borderWidth > 0
        
        var imageSize = CGSize(width: size.width, height: size.height)
        var strokeRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        if hasBorder {
            switch configuration.borderAlignment {
            case .inside:
                strokeRect.origin.x += configuration.borderWidth / 2
                strokeRect.origin.y += configuration.borderWidth / 2
                strokeRect.size.width -= configuration.borderWidth
                strokeRect.size.height -= configuration.borderWidth
                
            case .center:
                strokeRect.origin.x += configuration.borderWidth / 2
                strokeRect.origin.y += configuration.borderWidth / 2
                imageSize.width += configuration.borderWidth
                imageSize.height += configuration.borderWidth
                
            case .outside:
                strokeRect.origin.x += configuration.borderWidth / 2
                strokeRect.origin.y += configuration.borderWidth / 2
                strokeRect.size.width += configuration.borderWidth
                strokeRect.size.height += configuration.borderWidth
                imageSize.width += configuration.borderWidth * 2
                imageSize.height += configuration.borderWidth * 2
            }
            
        }
        
        
        let fillRect = !hasBorder ? strokeRect : CGRect(x: strokeRect.origin.x + borderWidth / 2,
                                                        y: strokeRect.origin.y + borderWidth / 2,
                                                        width: strokeRect.size.width - borderWidth,
                                                        height: strokeRect.size.height - borderWidth)
        
        let cornerRadius = maxCornerRadius
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()!
        
        var fillPath: UIBezierPath = UIBezierPath()
        var strokePath: UIBezierPath = UIBezierPath()
        
        if isAllCornerRadiusEquals && configuration.cornerRadius.topLeft > 0 {
            strokePath = UIBezierPath(roundedRect: strokeRect, cornerRadius: configuration.cornerRadius.topLeft)
            fillPath = UIBezierPath(roundedRect: fillRect, cornerRadius: configuration.cornerRadius.topLeft)
            
        } else if cornerRadius > 0 {
            let startAngle = CGFloat.pi
            
            let topLeftCenter = CGPoint(
                x: configuration.cornerRadius.topLeft + configuration.borderWidth / 2,
                y: configuration.cornerRadius.topLeft + configuration.borderWidth / 2
            )
            let topRightCenter = CGPoint(
                x: imageSize.width - configuration.cornerRadius.topRight - configuration.borderWidth / 2,
                y: configuration.cornerRadius.topRight + configuration.borderWidth / 2
            )
            let bottomRightCenter = CGPoint(
                x: imageSize.width - configuration.cornerRadius.bottomRight - configuration.borderWidth / 2,
                y: imageSize.height - configuration.cornerRadius.bottomRight - configuration.borderWidth / 2
            )
            let bottomLeftCenter = CGPoint(
                x: configuration.cornerRadius.bottomLeft + configuration.borderWidth / 2,
                y: imageSize.height - configuration.cornerRadius.bottomLeft - configuration.borderWidth / 2
            )
            
            let fillTopLeftCenter = !hasBorder ? topLeftCenter : CGPoint(
                x: topLeftCenter.x + borderWidth / 2,
                y: topLeftCenter.y + borderWidth / 2
            )
            let fillTopRightCenter = !hasBorder ? topRightCenter : CGPoint(
                x: topRightCenter.x - borderWidth / 2,
                y: topRightCenter.y + borderWidth / 2
            )
            let fillBottomRightCenter = !hasBorder ? bottomLeftCenter : CGPoint(
                x: bottomRightCenter.x - borderWidth / 2,
                y: bottomRightCenter.y - borderWidth / 2
            )
            let fillBottomLeftCenter = !hasBorder ? bottomRightCenter : CGPoint(
                x: bottomLeftCenter.x + borderWidth / 2,
                y: bottomLeftCenter.y - borderWidth / 2
            )
            
            
            // top left
            if configuration.cornerRadius.topLeft > 0 {
                strokePath.addArc(withCenter: topLeftCenter,
                                   radius: configuration.cornerRadius.topLeft,
                                   startAngle: startAngle,
                                   endAngle: 1.5 * startAngle,
                                   clockwise: true)
                fillPath.addArc(withCenter: fillTopLeftCenter,
                                   radius: configuration.cornerRadius.topLeft,
                                   startAngle: startAngle,
                                   endAngle: 1.5 * startAngle,
                                   clockwise: true)
            } else {
                strokePath.move(to: topLeftCenter)
                fillPath.move(to: fillTopLeftCenter)
            }
            
            // top right
            if configuration.cornerRadius.topRight > 0 {
                strokePath.addArc(withCenter: topRightCenter,
                                   radius: configuration.cornerRadius.topRight,
                                   startAngle: 1.5 * startAngle,
                                   endAngle: 2 * startAngle,
                                   clockwise: true)
                
                fillPath.addArc(withCenter: fillTopRightCenter,
                                radius: configuration.cornerRadius.topLeft,
                                startAngle: startAngle,
                                endAngle: 1.5 * startAngle,
                                clockwise: true)
            } else {
                strokePath.addLine(to: topRightCenter)
                fillPath.move(to: fillTopRightCenter)
            }
            
            // bottom right
            if configuration.cornerRadius.bottomRight > 0 {
                strokePath.addArc(withCenter: bottomRightCenter,
                                   radius: configuration.cornerRadius.bottomRight,
                                   startAngle: 2 * startAngle,
                                   endAngle: 2.5 * startAngle,
                                   clockwise: true)
                
                fillPath.addArc(withCenter: fillBottomRightCenter,
                                  radius: configuration.cornerRadius.bottomRight,
                                  startAngle: 2 * startAngle,
                                  endAngle: 2.5 * startAngle,
                                  clockwise: true)
            } else {
                strokePath.addLine(to: bottomRightCenter)
                fillPath.move(to: fillBottomRightCenter)
            }
            
            // bottom left
            if configuration.cornerRadius.bottomLeft > 0 {
                strokePath.addArc(withCenter: bottomLeftCenter,
                                   radius: configuration.cornerRadius.bottomLeft,
                                   startAngle: 2.5 * startAngle,
                                   endAngle: 3 * startAngle,
                                   clockwise: true)
                
                fillPath.addArc(withCenter: fillBottomLeftCenter,
                                  radius: configuration.cornerRadius.bottomLeft,
                                  startAngle: 2.5 * startAngle,
                                  endAngle: 3 * startAngle,
                                  clockwise: true)
            } else {
                strokePath.addLine(to: bottomLeftCenter)
                fillPath.move(to: fillBottomLeftCenter)
            }
            
            if configuration.cornerRadius.topLeft > 0 {
                strokePath.addLine(to: CGPoint(x: borderWidth / 2, y: topLeftCenter.y))
                fillPath.addLine(to: CGPoint(x: borderWidth, y: fillTopLeftCenter.y))
            } else {
                strokePath.addLine(to: topLeftCenter)
                fillPath.addLine(to: fillTopLeftCenter)
            }
            
        } else {
            strokePath = UIBezierPath(rect: strokeRect)
            fillPath = UIBezierPath(rect: fillRect)
        }
        
        // fill
        context.saveGState()
        
        if configuration.colors.count <= 1 {
            context.addPath(strokePath.cgPath)
            configuration.colors.first?.setFill()
            strokePath.fill()
            
        } else {
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors = configuration.colors.map { $0.cgColor } as CFArray
            
            if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: configuration.colorLocations) {
                let startPoint = CGPoint(x: configuration.colorStartPoint.x * imageSize.width,
                                         y: configuration.colorStartPoint.y * imageSize.height)
                let endPoint = CGPoint(x: configuration.colorEndPoint.x * imageSize.width,
                                       y: configuration.colorEndPoint.y * imageSize.height)
                context.addPath(strokePath.cgPath)
                context.clip()
                context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
            }
        }
        context.restoreGState()

        
        // stroke
        context.saveGState()
        
        if configuration.borderColors.count <= 1 {
            context.addPath(strokePath.cgPath)
            configuration.borderColors.first?.setStroke()
            strokePath.lineWidth = configuration.borderWidth
            strokePath.stroke()
            
        } else {
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors = configuration.borderColors.map { $0.cgColor } as CFArray
            
            if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: configuration.borderColorLocations) {
                let startPoint = CGPoint(x: configuration.borderColorStartPoint.x * imageSize.width,
                                         y: configuration.borderColorStartPoint.y * imageSize.height)
                let endPoint = CGPoint(x: configuration.borderColorEndPoint.x * imageSize.width,
                                       y: configuration.borderColorEndPoint.y * imageSize.height)
                context.addPath(strokePath.cgPath)
                context.setLineWidth(configuration.borderWidth)
                context.replacePathWithStrokedPath()
                context.clip()
                context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
            }
        }
        context.restoreGState()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

public extension ImageFactory {
    
    /// Draw an image on another image
    ///
    /// - Parameters:
    ///   - lhs: Image at top
    ///   - rhs: Image at bottom
    /// - Returns: An `UIImage` object
    public class func merge(_ image: UIImage, with another: UIImage) -> UIImage? {
        return UIImage.draw(image: image, on: another)
    }
}

