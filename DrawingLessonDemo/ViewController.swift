//
//  ViewController.swift
//  DrawingLessonDemo
//
//  Created by hovhannes safaryan on 9/17/19.
//  Copyright © 2019 hovhannes safaryan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var drawingView: DrawingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tapGR = UITapGestureRecognizer(target: self, action: Selector(("didTap:")))
//        self.view.addGestureRecognizer(tapGR)
        // Do any additional setup after loading the view.
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
        drawingView.undoDrawingView()
    }
    
    
    @IBAction func redoButton(_ sender: UIButton) {
        drawingView.redoDrawingView()
    }
    
    
    @IBAction func resetViewButton(_ sender: UIButton) {
        drawingView.reset()
    }
    
    @IBAction func changepathlocation(_ sender: UIButton) {
        
        drawingView.movetoNewPlace()
    }
    
    @IBAction func clear(_ sender: UIButton) {
        drawingView.mode = .clear
    }
    
    
    
    
    
//    @IBAction func panGR(_ sender: UIPanGestureRecognizer) {
//        
//    }
//    
    
    
    
    
    @IBAction func draw(_ sender: UIButton) {
    drawingView.mode = .draw
    }
    
    
    
}

