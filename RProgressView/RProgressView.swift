//
//  bPathView.swift
//  bPath
//
//  Created by Jawad Ali on 06/09/2020.
//  Copyright © 2020 Jawad Ali. All rights reserved.
//

import UIKit

@IBDesignable public class RProgressView: UIView {
    
    //MARK:- Properties
    public var isMultiColour: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var dotColors: [UIColor?] = [#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) , #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var mainDotColor: UIColor = #colorLiteral(red: 0.07366103679, green: 0.5809653997, blue: 0.9120218158, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var speed: Double = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var width:CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var numberOfCircles:Int = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private lazy var allCircles:[CAShapeLayer] = [CAShapeLayer]()
    
    //MARK:- Initializers
    
    convenience public init (with color: [UIColor]) {
        self.init(frame:.zero)
        self.dotColors = color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        controlDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        controlDidLoad()
    }
    
    //MARK:- View Lifecycle
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        let radius: CGFloat = min(bounds.midX,bounds.midY )
        let mainCenter =  CGPoint(x: bounds.midX, y: bounds.midY)
        
         _ = layer.sublayers.map { $0.map{ $0.removeFromSuperlayer() } }
        
        let centerDotLayer = getDotLayer(at: mainCenter, size: radius * 0.2, color: mainDotColor  )
        centerDotLayer.frame = bounds
        layer.addSublayer(centerDotLayer)
        
        allCircles.removeAll()
        for i in 1...numberOfCircles {
            
            let color = isMultiColour ?  (i <= dotColors.count ?  dotColors[i-1] ??  mainDotColor : mainDotColor ) : mainDotColor
            
            let circle = drawCircularLayer(with: CGFloat(Int(radius) * i/numberOfCircles), color: color)
            layer.addSublayer(circle)
            allCircles.append(circle)
        }
        
        for (index,shapeLayer) in allCircles.enumerated() {
            shapeLayer.rotateAnimation(angal: 2 * .pi, duration: speed + Double(index), repeatAnimation: true)
        }
    }
    
    private func controlDidLoad(){
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK:- Start Stop Animation
    private func setUpConstraints(with view: UIView) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
    
    public func stopAnimating() {
        for shapeLayer in allCircles {
            shapeLayer.removeAllAnimations()
        }
        
        layer.removeAllAnimations()
        self.removeFromSuperview()
    }
    
    public func startAnimating(in view : UIView , isConstraintsSet:Bool = false) {
        
        view.addSubview(self)
        layoutIfNeeded()
        if !isConstraintsSet {
            setUpConstraints(with: view)
        }
    }
}

//MARK:- Drawing paths
private extension RProgressView {
    func drawCircularLayer(with radius:CGFloat, color: UIColor) -> CAShapeLayer {
        let bezierPath = UIBezierPath()
        
        let circularLayer = CAShapeLayer()
        circularLayer.fillColor = UIColor.clear.cgColor
        circularLayer.strokeColor = color.cgColor
        circularLayer.lineWidth = width
        
        let center =  CGPoint(x: bounds.midX, y: bounds.midY)
        let miniCircleRadius = radius
        
        let  x1 = center.x  + (radius ) *  cos(-80.degreesToRadians)
        let  y1 = center.y  + (radius ) *  sin(-80.degreesToRadians)
        
        bezierPath.move(to: CGPoint(x: x1, y: y1))
        bezierPath.addArc(withCenter: center, radius: miniCircleRadius, startAngle: -80.degreesToRadians, endAngle: 80.degreesToRadians, clockwise: true)
        
        circularLayer.addSublayer(getDotLayer(at: bezierPath.currentPoint, size: radius * 0.2, color: color))
        
        let  x2 = center.x  + (radius ) *  cos(100.degreesToRadians)
        let  y2 = center.y  + (radius ) *  sin(100.degreesToRadians)
        
        bezierPath.move(to: CGPoint(x: x2, y: y2))
        bezierPath.addArc(withCenter: center, radius: miniCircleRadius, startAngle: 100.degreesToRadians, endAngle: 260.degreesToRadians, clockwise: true)
        
        circularLayer.addSublayer(getDotLayer(at: bezierPath.currentPoint, size: radius * 0.2, color: color))
        circularLayer.path = bezierPath.cgPath
        circularLayer.frame = bounds
        return circularLayer
    }
    
    func getDotLayer(at point:CGPoint, size: CGFloat, color: UIColor) -> CAShapeLayer {
        
     let  reSize = size > 15 ? ( size - size/3) : size
        
        let dot = CAShapeLayer()
        dot.fillColor = color.cgColor
        dot.path =  UIBezierPath(arcCenter: point, radius: reSize , startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
        return dot
    }
}
