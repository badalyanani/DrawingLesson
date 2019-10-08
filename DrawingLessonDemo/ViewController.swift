//
//  ViewController.swift
//  DrawingLessonDemo
//
//  Created by Ani Namalyann on 9/17/19.
//  Copyright © 2019 Ani Namalyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var selectedLayer: ShapeLayerType?
      var removeLayerIndexCount = 0
      var panGesture: UIPanGestureRecognizer!
      var tapGesture: UITapGestureRecognizer!
      var moveShapeLayer: ShapeLayerType?
      var shapeLayerColor: UIColor = .black
    
      var locationLayer = [(ShapeLayerType , CGPoint)]()

    @IBOutlet weak var drawingView: DrawingView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGestures()
        

    }
    
    private func setupGestures() {
          tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
          panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(recognizer:)))
          drawingView.addGestureRecognizer(panGesture)
          drawingView.addGestureRecognizer(tapGesture)
          tapGesture.isEnabled = false
          panGesture.isEnabled = false
      }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
          switch gesture.state {
          case .began, .ended:
              let touchLocation = gesture.location(in: drawingView)
              selectLayer(at: touchLocation)
          default:
              break
          }
      }
    
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
         
         switch recognizer.state {
         case .began:
             let touchLocation = recognizer.location(in: drawingView)
             selectLayer(at: touchLocation)
         case .changed:
             guard let layer = selectedLayer else { return }
             let translation = recognizer.translation(in: recognizer.view)
             CATransaction.begin();
             CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
          
            //print(layer.drawLayer.position)
            layer.drawLayer.position = CGPoint(x: layer.drawLayer.position.x + translation.x, y: layer.drawLayer.position.y + translation.y)
        
             drawingView.draw(drawingView.bounds)
             recognizer.setTranslation(CGPoint.zero, in: drawingView)

             CATransaction.commit();
             
             
         case .ended:
           
             guard let _ = selectedLayer else { return }
             
             print(drawingView.shapeLayers.count)
         default:
             break
         }
        
     }
    private func selectLayer(at loc: CGPoint) {
        let newLocation = drawingView.layer.convert(loc, to: drawingView.layer.superlayer)
        let layer = drawingView.layer.hitTest(newLocation)
        guard let shapeLayer = layer as? ShapeLayer else {
            print("Hit test returned layer of type: \(type(of: layer))")
            selectedLayer = nil
            return
        }
        print("Selected layer at location: \(loc)")
        selectedLayer?.drawLayer.zPosition = 0.0
        selectedLayer = ShapeLayerType(shapeLayer: shapeLayer,
                                       color: shapeLayerColor)
        shapeLayer.zPosition = 1.0
    }


    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    
    @IBAction func brushSizeChanger(_ sender: UISlider) {
        
        drawingView.changeBrush(brushSize: sender)
    }
    
 
    @IBAction func colorPressed(_ sender: UIButton) {

        drawingView.changeColor(changeColor: sender.backgroundColor ?? UIColor.blue)
        

    }
    
    @IBAction func undoButton(_ sender: UIButton) {

        print(locationLayer.count)
        drawingView.undoLayer()
        
        
    }
    
    
    @IBAction func redoButton(_ sender: UIButton) {
        drawingView.redoLayer()
          print(drawingView.shapeLayers.count)
        
    }
    
    
    @IBAction func resetViewButton(_ sender: UIButton) {
        drawingView.reset()
    }
    
  
    
    @IBAction func clear(_ sender: UIButton) {
        drawingView.mode = .clear
        drawingView.clearView()
        
    }
    
    
    @IBAction func drawMode(_ sender: UISegmentedControl) {
        tapGesture.isEnabled = sender.selectedSegmentIndex == 1
               panGesture.isEnabled = sender.selectedSegmentIndex == 1
               
               drawingView.mode = sender.selectedSegmentIndex == 1 ? .move : .draw
    }
    

    
}

