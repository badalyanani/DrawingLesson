//
//  DrawingView.swift
//  DrawingLessonDemo
//
//  Created by hovhannes safaryan on 9/17/19.
//  Copyright © 2019 hovhannes safaryan. All rights reserved.
//
import UIKit.UIGestureRecognizerSubclass
import UIKit

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
    }
    
    
    enum State {
        case Began
        case Ended
    }
    
    
    // var pathRecognizer: UIPanGestureRecognizer
    
    var mode: Mode = .draw
    
    var state: State = .Ended
    //var pathArray: [UIBezierPath]
    
    static var  count = 0
    var color: UIColor = UIColor.black
    
    var size: CGSize = CGSize.init()
    
    var path = UIBezierPath()
    
    var paths = [PathType]()
    
    var pathForRedo = [PathType]()
    
    var lineWidth: CGFloat = 10
    
    var maskImageView = UIImageView()
    
    var pathsCoordinates = [PathType]()
    
    
    //    var pathRecognizer = UIPanGestureRecognizer( target: self, action: Selector("pathed:"))
    
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
        let touch = touches.first!
        //setupPath()
        path = UIBezierPath()
        path.lineWidth = lineWidth
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        //pathArray.append(path)
        
        paths.append(PathType(path: path, color:( mode == .clear ? self.backgroundColor :  color)!))
        path.move(to: touch.location(in: self))
        
        updateMaskImageView()
        if (state == .Began){

            for path in paths{
                if(touch.location(in: self).x == path.path.currentPoint.x ){
                    if(touch.location(in: self).y == path.path.currentPoint.y){
                        pathsCoordinates.append(path)
                        
                        
                    }
                }


            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        path.addLine(to: touch.location(in: self))
        updateMaskImageView()
        
        
        
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        endTouches(at: touch.location(in: self))
        setNeedsDisplay()
        
        //        state = .Ended
        
        //pathsCoordinates.rem
        
        
        if(state == .Began){
         // var newPlacePath =  pathsCoordinates.removeLast()
//            newPlacePath.path.currentPoint.x = touch.location(in: self).x
//            newPlacePath.path.currentPoint.y = touch.location(in: self).y
            
//            newPlacePath.path.move(to: touch.location(in: self))
            
            
            
            
            
            
            
            
//            convertPathsToImage(pathsCoordinates)
            
            
            state = .Ended

        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        endTouches(at: touch.location(in: self))
    }
    
    func endTouches(at point: CGPoint) {
        path.addLine(to: point)
        print("KAR:: + \(path.lineWidth)")
        updateMaskImageView()
        
        
    }
    
    func updateMaskImageView() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        //        maskImageView.image?.draw(in: bounds)
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
    
    //    func pathed(c: UIPanGestureRecognizer) {
    //        if c.state == .ended {
    //        let center = c.locationInView(UIView)
    //        findCircledView(center)
    //      }
    //    }
    
    
    
    
    
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
    
    
    func redoDrawingView(){
        if !pathForRedo.isEmpty {
            paths.append(pathForRedo.removeLast())
        }
        setNeedsDisplay()
        
        
    }
    
    
    func reset(){
        if !paths.isEmpty {
            paths.removeAll()
        }
        setNeedsDisplay()
    }
    
    
    
    
    func movetoNewPlace(){
        
        state = .Began
        
        
    }
    
    
    
//    func createPanGestureRecognizer(targetView: UIImageView) {
//        var panGesture = UIPanGestureRecognizer(target: self, action:(Selector("handlePanGesture:")))
//        targetView.addGestureRecognizer(panGesture)
//    }
//    func handlePanGesture(panGesture: UIPanGestureRecognizer) {
//        // get translation
//        var translation = panGesture.translationInView(pat)
//        panGesture.setTranslation(CGPointZero, inView: view)
//        println(translation)
//
//        // create a new Label and give it the parameters of the old one
//        var label = panGesture.view as UIImageView
//        label.center = CGPoint(x: label.center.x+translation.x, y: label.center.y+translation.y)
//        label.multipleTouchEnabled = true
//        label.userInteractionEnabled = true
//
//        if panGesture.state == UIGestureRecognizerState.Began {
//            // add something you want to happen when the Label Panning has started
//        }
//
//        if panGesture.state == UIGestureRecognizerState.Ended {
//            // add something you want to happen when the Label Panning has ended
//        }
//
//        if panGesture.state == UIGestureRecognizerState.Changed {
//            // add something you want to happen when the Label Panning has been change ( during the moving/panning )
//        } else {
//            // or something when its not moving
//        }
//    }
    
    
    
//    func convertPathsToImage(paths: [UIBezierPath]) -> UIImage
//    {
//        let imageWidth: CGFloat = lineWidth
//        let imageHeight: CGFloat  = 20.0
//        var newpath = [PathType]()
//
//        for path in paths{
//            newpath.append(path)
//        }
//
//        // Make a graphics context
//
//        let context = UIGraphicsGetCurrentContext()
//
//
//
//
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//
//        UIGraphicsEndImageContext()
//
//        return image
//    }


    override func draw(_ rect: CGRect) {
        
        if(state == .Ended){
        
        for members in paths{
            members.color.setStroke()
            members.path.stroke()
        }
        
        //setNeedsDisplay()
        
    }
    }
    
}
