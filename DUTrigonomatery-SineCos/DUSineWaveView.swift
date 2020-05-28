//
//  DUSineWaveView.swift
//  DUTrigonomatery-SineCos
//
//  Created by Dhaval Trivedi on 28/05/20.
//  Copyright © 2020 Dhaval Trivedi. All rights reserved.
//


import UIKit

protocol DUSineWaveViewDelegate {
    func getValueAtPoint(degree: Int, radian: Double, xVal: Double, yVal: Double)
    func setValueFromSelectedPoint(graphVal: DUGraphValues)
}

class DUSineWaveView: UIView {
    
    //MARK: - Variables
    
    var frequency: Double = 1.0  // Graph width
    var amplitude: Double = 0.3  // Amplitude
    var dotViewWidth: Double = 16.0
    var isMultipleDots = true
    var isSyncOn = true
    var isFirstTime = true
    var isShowScaling = false
    var isPointSelection = false
    var arrGraphValues = [DUGraphValues]()
    var arrSelectedPoints = [DUGraphValues]()
    var arrAmpltudeBaselines = [CGFloat]()
    var arrFrequencyBaselines = [CGFloat]()
    var distanceBetweenPoints = 1.0
    var selectedPointColor = UIColor(named: "Blueish")
    var selectedPoint: DUGraphValues?
    var delegate: DUSineWaveViewDelegate?
    var maxGraphLegth: CGFloat = 100.0
    var maxGraphHeight: CGFloat = 10.0
    var isCosWave = false
    
    //MARK: - Lifecycle methods
    
    override func draw(_ rect: CGRect) {
        if isFirstTime {
            isFirstTime = false
            addAmplitudeLabels(rect: rect)
            addLFrequencyLabels(rect: rect)
        }
        addSineWaveIn(rect: rect)
        addCentreLineAtYposition(rect: rect)
        setFunctioality()
        addRandomFloatingPointsReference(rect: rect)
        if isShowScaling {
            addAmplitudeScaling(width: rect.width)
            addFrequencyScaling(height: rect.height)
        }
        if selectedPoint != nil {
            drawRectAroundPoint(point: CGPoint.init(x: selectedPoint!.rectX, y: selectedPoint!.rectY))
            //  drawRectAroundPoint(point: CGPoint.init(x: 100, y: 100))
        }
    }
    
    //MARK: - Other Methods
    
    func setFunctioality() {
        if isSyncOn {
            let graph = arrGraphValues.filter {
                for obj in arrSelectedPoints {
                    if obj.index == $0.index {
                        $0.color = obj.color
                        return true
                    }
                }
                return false
            }
            for graphVal in graph {
                delegate?.getValueAtPoint(degree: graphVal.degree, radian: graphVal.radians, xVal: graphVal.rectX, yVal: graphVal.rectY)
                putPointOn(x: graphVal.rectX, y: graphVal.rectY, color: graphVal.color)
            }
        } else {
            for obj in arrSelectedPoints {
                putPointOn(x: Double(obj.rectX), y: Double(obj.rectY), color: obj.color)
            }
        }
    }
    
    func addSineWaveIn(rect: CGRect) {
        let width = rect.width
        let height = rect.height
        if frequency != 0 {
            arrGraphValues.removeAll()
            //print("STARTT")
            for currentFreq in stride(from: 0.0, to: 1.0, by: frequency) {
                let origin = CGPoint(x: CGFloat(currentFreq), y: height * 0.5)
                let sineWavePath = UIBezierPath()
                sineWavePath.removeAllPoints()
                sineWavePath.move(to: origin)
                var n = 0
                for degree in stride(from: 0.0, through: (360.0 * frequency), by: distanceBetweenPoints) {
                    //  print("increaseBy: ", distanceBetweenPoints, "through: \(360.0 * frequency)")
                    let x = CGFloat(degree/(180 * frequency)) * width
                    var y_plot: Double = 0.0
                    let Ø = (degree/180.0 * Double.pi)
                    if isCosWave {
                        y_plot = cos(Ø)
                    } else {
                        y_plot = sin(Ø)
                    }
                    let y = origin.y - CGFloat(y_plot) * height * CGFloat(amplitude)
                    sineWavePath.addLine(to: CGPoint(x: x, y: y))
                    //Degree to radian formula
                    let radians = degree * .pi / 180
                    let xDiff = rect.width / maxGraphLegth
                    let yDiff = rect.height / maxGraphHeight
                    let graph = DUGraphValues(degree: Int(degree), radians: radians, xVal: Double(xDiff), yVal: Double(yDiff), index: n, color: selectedPointColor!, rectX: Double(x), rectY: Double(y))
                    arrGraphValues.append(graph)
                    n += 1
                    // print("Degrees: \(String(format:"%.2f", degree)), radians: \(String(format:"%.2f", radians)), X: \(String(format:"%.2f", x / xDiff)), Y: \(String(format:"%.2f",y / yDiff)), Amplitude: \(String(format:"%.2f", amplitude))")
                }
                UIColor.black.setStroke()
                sineWavePath.stroke()
            }
            //print("FINISHH")
        }
    }
    
    func addRandomFloatingPointsReference(rect: CGRect) {
        if arrGraphValues.count != 0 {
            let val1 = arrGraphValues[arrGraphValues.count / 4]
            let val2 = arrGraphValues[arrGraphValues.count / 5]
            let val3 = arrGraphValues[arrGraphValues.count / 3]
            let val4 = arrGraphValues[arrGraphValues.count / 23]
            //  print("Ref at x: ",val2.xVal, " y: ", val2.yVal, " , degree: ", val1.degree)
            putPointOn(x: val1.rectX, y: val1.rectY, color: nil)
            putPointOn(x: val2.rectX, y: val2.rectY, color: nil)
            putPointOn(x: val3.rectX, y: val3.rectY, color: nil)
            putPointOn(x: val4.rectX, y: val4.rectY, color: nil)
            floatingPointLineIndicator(rect: rect, xVal: CGFloat(val1.rectX))
            floatingPointLineIndicator(rect: rect, xVal: CGFloat(val2.rectX))
            floatingPointLineIndicator(rect: rect, xVal: CGFloat(val3.rectX))
            floatingPointLineIndicator(rect: rect, xVal: CGFloat(val4.rectX))
        }
    }
    
    func addLFrequencyLabels(rect: CGRect) {
        var n = 0
        for xPos in stride(from: 0.0, to: rect.width, by: (rect.width / 40.0)) {
            //            let origin = CGPoint.init(x: xPos - 15, y: rect.height + 10)
            //            let lbl = UILabel(frame: CGRect(origin: origin, size: CGSize.init(width: 30, height: 20)))
            //            lbl.backgroundColor = UIColor.white
            //            lbl.clipsToBounds = false
            //            lbl.textColor = UIColor.black
            //            lbl.text = n.description
            //            lbl.font = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? UIFont.systemFont(ofSize: 20) : UIFont.systemFont(ofSize: 11)
            //            lbl.textAlignment = .center
            //            self.addSubview(lbl)
            arrFrequencyBaselines.append(xPos)
            n += 1
        }
    }
    
    func addAmplitudeLabels(rect: CGRect) {
        var n = 0.0
        arrAmpltudeBaselines.removeAll()
        for yPos in stride(from: 0.0, to: rect.height, by: (rect.height / 10)) {
            let origin = CGPoint.init(x: -50, y: yPos - 10)
            let lbl = UILabel(frame: CGRect(origin: origin, size: CGSize.init(width: 50, height: 20)))
            lbl.backgroundColor = UIColor.white
            lbl.textColor = UIColor.black
            let val = n - 1.0
            let str = String(format:"%.1f", val)
            if val < 0  {
                lbl.text = str.replacingOccurrences(of: "-", with: "")
            } else if val == 0 {
                lbl.text = "0"
            } else {
                lbl.text = "-" + str
            }
            lbl.font = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? UIFont.systemFont(ofSize: 20) : UIFont.systemFont(ofSize: 11)
            lbl.textAlignment = .center
            self.addSubview(lbl)
            arrAmpltudeBaselines.append(yPos)
            n += 0.2
        }
    }
    
    func addAmplitudeScaling(width: CGFloat) {
        for yPos in arrAmpltudeBaselines {
            let origin = CGPoint.init(x: 0, y: yPos)
            let path = UIBezierPath()
            path.move(to: origin)
            path.addLine(to: CGPoint(x: width, y: yPos))
            path.lineWidth = 0.6
            UIColor.lightGray.setStroke()
            path.stroke()
        }
    }
    
    func addFrequencyScaling(height: CGFloat) {
        for xPos in arrFrequencyBaselines {
            let origin = CGPoint.init(x: xPos, y: 0)
            let path = UIBezierPath()
            path.move(to: origin)
            path.addLine(to: CGPoint(x: xPos, y: height))
            path.lineWidth = 0.6
            UIColor.lightGray.setStroke()
            path.stroke()
        }
    }
    
    func addCentreLineAtYposition(rect: CGRect) {
        let yPos = rect.height * 0.5
        let origin = CGPoint.init(x: 0, y: yPos)
        let path = UIBezierPath()
        path.move(to: origin)
        path.lineWidth = 2.0
        path.addLine(to: CGPoint(x: rect.width, y: yPos))
        UIColor.lightGray.setStroke()
        path.stroke()
    }
    
    func floatingPointLineIndicator(rect: CGRect, xVal: CGFloat) {
        let origin = CGPoint.init(x: xVal, y: 0)
        let path = UIBezierPath()
        path.move(to: origin)
        path.addLine(to: CGPoint(x: xVal, y: rect.height))
        path.lineWidth = 0.6
        UIColor.red.setStroke()
        path.stroke()
    }
    
    func putPointOn(x: Double, y: Double, color: UIColor?) {
        let dot = UIBezierPath(ovalIn: CGRect(origin: CGPoint.init(x: x - dotViewWidth / 2, y: y - dotViewWidth / 2), size: CGSize(width: dotViewWidth, height: dotViewWidth)))
        if color == nil {
            UIColor.orange.setFill()
            UIColor.red.setStroke()
        } else {
            color!.setFill()
            UIColor.black.setStroke()
        }
        dot.stroke()
        dot.fill()
    }
    
    func drawRectAroundPoint(point: CGPoint) {
        let drect = CGRect(x: point.x - 15,y: point.y - 15,width: 30,height: 30)
        let bpath = UIBezierPath(rect: drect)
        UIColor.clear.setFill()
        UIColor.black.setStroke()
        bpath.stroke()
        bpath.fill()
    }
    
    func removeDot() {
        arrSelectedPoints.removeAll()
        self.setNeedsDisplay()
    }
    
}

extension DUSineWaveView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchAtPt(touches, with: event)
    }
    
    func touchAtPt(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            //            print("X: ", currentPoint.x, "Y: ", currentPoint.y)
            let sqaure = CGRect.init(x: currentPoint.x - 5, y: currentPoint.y - 5, width: 10, height: 10)
            let interactions = self.arrGraphValues.filter {
                let pt = CGPoint.init(x: $0.rectX, y: $0.rectY)
                return sqaure.contains(pt)
            }
            if interactions.count != 0 {
                let centreObj = Int(interactions.count / 2)
                let centrePt = interactions[centreObj]
                if !isMultipleDots && !isPointSelection{
                    arrSelectedPoints.removeAll()
                }
                if isPointSelection {
                    for obj in arrSelectedPoints {
                        let graph = interactions.filter {
                            return obj.degree == $0.degree
                        }
                        if let val = graph.first {
                            selectedPoint = val
                            delegate?.setValueFromSelectedPoint(graphVal: val)
                            setNeedsDisplay()
                            break
                        }
                    }
                } else {
                    centrePt.color = selectedPointColor!
                    arrSelectedPoints.append(centrePt)
                    self.setNeedsDisplay()
                }
            }
        }
    }
    
}
