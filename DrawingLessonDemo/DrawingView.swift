//
//  DrawingView.swift
//  DrawingLessonDemo
//
//  Created by Ani Namalyan on 9/17/19.
//  Copyright © 2019 Ani Namalyan. All rights reserved.
//
import UIKit.UIGestureRecognizerSubclass
import UIKit


struct ShapeLayerType {
    var drawLayer: CAShapeLayer
    var color: UIColor
    
    init(shapeLayer: CAShapeLayer, color: UIColor) {
        self.drawLayer = shapeLayer
        self.color = color
    }
}

class ShapeLayer: CAShapeLayer {
    override func contains(_ p: CGPoint) -> Bool {
        guard let path = path?.copy(strokingWithWidth: max(lineWidth, 20),
                                    lineCap: .round,
                                    lineJoin: .round,
                                    miterLimit: .nan) else { return false }
        return path.contains(p)
    }
    
}

struct PathType{
    var path: UIBezierPath
    var color: UIColor
    
    init(path: UIBezierPath, color: UIColor) {
        self.path = path
        self.color = color
    }
}

class DrawingView: UIView {
    
    enum Mode {
        case draw
        case clear
        case move
    }
    
    var mode: Mode = .draw
    
    var shapeLayers = [ShapeLayerType]()
    var shapeLayer: CAShapeLayer!
    var undoLayers = [ShapeLayerType]()
    
    static var  count = 0
    var color: UIColor = .black
    var size: CGSize = CGSize.init()
    var path = UIBezierPath()
    var paths = [PathType]()
    var pathForRedo = [PathType]()
    var lineWidth: CGFloat = 10
    var maskImageView = UIImageView()
    var pathsCoordinates = [PathType]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        self.addSubview(maskImageView)
        maskImageView.frame = bounds
    }
    
    //gci ezrern enq kloracnum
    func setupPath() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        path.lineWidth = 1
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if mode == .draw || mode == .clear {
            
            let touch = touches.first!
            
            path = UIBezierPath()
            path.lineWidth = lineWidth
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            path.lineJoinStyle = .round
            //pathArray.append(path)
            
            
            paths.append(PathType(path: path, color:( mode == .clear ? self.backgroundColor :  color)!))
            path.move(to: touch.location(in: self))
            undoLayers = []
        }
        setNeedsDisplay()
        updateMaskImageView()
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode == .draw || mode == .clear{
            let touch = touches.first!
            path.addLine(to: touch.location(in: self))
        }
        setNeedsDisplay()
        updateMaskImageView()
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode == .draw || mode == .clear{
            let touch = touches.first!
            endTouches(at: touch.location(in: self))
            touchEnded()
        }
        setNeedsDisplay()
        updateMaskImageView()
        
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode == .draw || mode == .clear{
            let touch = touches.first!
            endTouches(at: touch.location(in: self))
            touchEnded()
        }
        setNeedsDisplay()
        updateMaskImageView()
        
    }
    
    func endTouches(at point: CGPoint) {
        path.addLine(to: point)
        print("KAR:: + \(path.lineWidth)")
        updateMaskImageView()
        
    }
    
    
    func touchEnded() {
        shapeLayer = ShapeLayer()
        shapeLayer.frame = path.bounds
        path.apply(CGAffineTransform(translationX: -path.bounds.origin.x, y: -path.bounds.origin.y))
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = path.lineWidth
        shapeLayer.opacity = 1
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = nil
        shapeLayers.append(ShapeLayerType(shapeLayer: shapeLayer, color: color))
        layer.addSublayer(shapeLayer)
        path.removeAllPoints()
        updateMaskImageView()
        setNeedsDisplay()
    }
    
    func updateMaskImageView() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        color.setStroke()
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        maskImageView.image = img
        
        setNeedsDisplay()
    }
    
    func changeColor(changeColor: UIColor){
        
        color = changeColor
        
        setNeedsDisplay()
    }
    
    func  changeBrush(brushSize: UISlider){
        // print("ANi:: + \(brushSize.value)")
        //print(CGFloat(brushSize.value))
        lineWidth = CGFloat(brushSize.value)
        
    }
    
    func undoDrawingView(){
        
        if !paths.isEmpty{
            pathForRedo.append(paths.removeLast())
            setNeedsDisplay()
        }
    }
    
    
    
    func clearView(){
        self.changeColor(changeColor: self.backgroundColor!)
        
    }
    
    func redoDrawingView(){
        if !pathForRedo.isEmpty {
            paths.append(pathForRedo.removeLast())
        }
        setNeedsDisplay()
    }
    
    
    func reset(){
        
        if !shapeLayers.isEmpty {
            for _ in shapeLayers {
                layer.sublayers?.removeLast()
            }
            path = UIBezierPath()
        }
        setNeedsDisplay()
        
    }
    
    func undoLayer() {
        guard !shapeLayers.isEmpty, let _ = layer.sublayers, let lastIndex = layer.sublayers?.count else { return }
        print(shapeLayers.count)
        layer.sublayers?.remove(at: lastIndex - 1)
        undoLayers.append(shapeLayers.removeLast())
        path = UIBezierPath()
        setNeedsDisplay()
    }
    
    func redoLayer() {
        guard !undoLayers.isEmpty else { return }
        shapeLayers.append(undoLayers.removeLast())
        layer.addSublayer(shapeLayers.last!.drawLayer)
        setNeedsDisplay()
    }
    
    
    override func draw(_ rect: CGRect) {
        
        if(mode == .draw || mode == .clear){
            color.setStroke()
            path.stroke()
            
        }
    }
}

