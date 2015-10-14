//
//  springVIew.swift
//  MuelleAmortiguado
//
//  Created by g336 DIT UPM on 8/10/15.
//  Copyright © 2015 g336 DIT UPM. All rights reserved.
//

import UIKit

struct Point{
    var x = 0.0
    var y = 0.0
}

protocol springViewDataSource : class{
    func startTimeOfSpringView( springView: SpringView ) -> Double
    func endTimeOfSpringView(springView: SpringView)-> Double
    func pointOfSpringView(springView: SpringView, atTime t: Double)-> Point
}


@IBDesignable
class SpringView : UIView{
    
    var scale: Double = 1.0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    var resolution: Double = 3000.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var lineWidth : Double = 3.0
    
    #if TARGET_INTERFACE_BUILDER
        var dataSource: springViewDataSource!
    #else
        weak var dataSource: springViewDataSource!
    #endif
    
    override func prepareForInterfaceBuilder(){
        class FakeDataSource: springViewDataSource{
        
            func startTimeOfSpringView(functionView: SpringView) -> Double{
                return 0
            }
            
            func endTimeOfSpringView(functionView: SpringView)-> Double {
                return 200
            }
            
            func pointOfSpringView(functionView: SpringView, atTime t: Double ) -> Point {
                return Point(x: t, y: t%50)
            }
            
        }
        dataSource = FakeDataSource()
    }
    
    override func drawRect(rect: CGRect) {
        drawAxis()
        drawFunction()
    }
    
    private func drawFunction() {
        
        let startTime = dataSource.startTimeOfSpringView(self)
        let endTime = dataSource.endTimeOfSpringView(self)
        let incrTime = max((endTime - startTime) / resolution , 0.01)
        let path = UIBezierPath()
        let color = UIColor.redColor()
        color.setStroke()
        
        var position = dataSource.pointOfSpringView(self, atTime: startTime)
        var x = xPosition(position.x)
        var y = yPosition(position.y)
        
        path.moveToPoint(CGPointMake(x, y))
        
        for var t = startTime ; t < endTime ; t += incrTime {
            position = dataSource.pointOfSpringView(self, atTime: t)
            x = xPosition(position.x)
            y = yPosition(position.y)
            path.addLineToPoint(CGPointMake(x, y))
        }
        
        path.lineWidth = CGFloat(lineWidth)
        
        path.stroke()
    }
    
    
    private func drawAxis() {
    
        let width = bounds.size.width
        let height = bounds.size.height
        
        let yaxis = UIBezierPath()
        yaxis.moveToPoint(CGPointMake(width/2, 0))
        yaxis.addLineToPoint(CGPointMake(width/2, height))
       
        let xaxis = UIBezierPath()
        xaxis.moveToPoint(CGPointMake(0, height/2))
        xaxis.addLineToPoint(CGPointMake(width, height/2))
        
        UIColor.blackColor().setStroke()
        
        yaxis.stroke()
        xaxis.stroke()
        
        
    
    }
    
    private func xPosition(x: Double) -> CGFloat {
        let width = bounds.size.width
        return width/2 + CGFloat(x*30)
        
    }
    
    private func yPosition(y: Double) -> CGFloat {
        let height = bounds.size.height
        return height/2 - CGFloat(y*3.5)
    }
    
	}