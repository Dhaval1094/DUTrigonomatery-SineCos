//
//  DUViewController.swift
//  DUTrigonomatery-SineCos
//
//  Created by Dhaval Trivedi on 28/05/20.
//  Copyright © 2020 Dhaval Trivedi. All rights reserved.
//

import UIKit

class DUViewController: UIViewController, DUSineWaveViewDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var lblDistanceBetweenPoints: UILabel!
    @IBOutlet weak var viewUnitCircle: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var lblDegrees: UILabel!
    @IBOutlet weak var lblRadians: UILabel!
    @IBOutlet weak var viewSineWave: DUSineWaveView!
    @IBOutlet weak var lblFrequency: UILabel!
    @IBOutlet weak var lblAmplitude: UILabel!
    @IBOutlet weak var amplitudeSlider: UISlider!
    @IBOutlet weak var frequencySlider: UISlider!
    @IBOutlet weak var btnBlueDot: UIButton!
    @IBOutlet weak var btnRedDot: UIButton!
    @IBOutlet weak var sliderDistanceOfPoints: UISlider!
    
    //MARK: - Properties
    
    //    let maxAmplitude = 1.0
    //    let minAmplitude = -1.0
    //    let maxFrequency = 100.0
    //    let minFrequency = 0.01
    var amplitude: Double = 0.3
    var frequency: Double = 2.0
    var distanceBetweenPoints: Double = 1.0
    
    //MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        defaultSetUP()
    }
    
    //MARK: - Switch
    
    @IBAction func multipleDotsOptionValueChanged(_ sender: UISwitch) {
        viewSineWave.isMultipleDots = sender.isOn
        changeSineWave()
    }
    
    @IBAction func syncWithSineWaveValueChanged(_ sender: UISwitch) {
        viewSineWave.isSyncOn = sender.isOn
        changeSineWave()
    }
    
    @IBAction func showScalingValuChanged(_ sender: UISwitch) {
        viewSineWave.isShowScaling = sender.isOn
        viewSineWave.setNeedsDisplay()
    }
    
    //MARK: - Slider
    
    @IBAction func amplitudeValuChanged(_ sender: UISlider) {
        amplitude = Double(sender.value)
        changeSineWave()
    }
    
    @IBAction func frequencyValueChanged(_ sender: UISlider) {
        frequency = Double(sender.value)
        changeSineWave()
    }
    
    @IBAction func sliderDistanceBetweenPointsClicked(_ sender: UISlider) {
        self.distanceBetweenPoints = Double(sender.value)
        changeSineWave()
    }
    
    //MARK: - Buttons
    
    @IBAction func btnAmplitudePlusClicked(_ sender: Any) {
        if (amplitude * 2.0) < Double(amplitudeSlider.maximumValue) {
            amplitude = amplitude + 0.1
            amplitudeSlider.value = Float(amplitude)
            changeSineWave()
        }
    }
    
    @IBAction func btnAmplitudeMinusClicked(_ sender: Any) {
        if (amplitude * 2.0) > Double(amplitudeSlider.minimumValue) {
            amplitude = amplitude - 0.1
            amplitudeSlider.value = Float(amplitude)
            changeSineWave()
        }
    }
    
    @IBAction func btnFrequencyPlusClicked(_ sender: Any) {
        if frequency < Double(frequencySlider.maximumValue) {
            frequency = frequency + 0.1
            frequencySlider.value = Float(frequency)
            changeSineWave()
        }
    }
    
    @IBAction func btnFrequencyMinusClicked(_ sender: Any) {
        if frequency > Double(frequencySlider.minimumValue) {
            frequency = frequency - 0.1
            frequencySlider.value = Float(frequency)
            changeSineWave()
        }
    }
    
    @IBAction func btnDistanceBetweenPointsPlusClicked(_ sender: Any) {
        if distanceBetweenPoints < Double(sliderDistanceOfPoints.maximumValue) {
            distanceBetweenPoints = distanceBetweenPoints + 0.1
            sliderDistanceOfPoints.value = Float(distanceBetweenPoints)
            changeSineWave()
        }
    }
    
    @IBAction func btnDistanceBetweenPointsMinusClicked(_ sender: Any) {
        if distanceBetweenPoints > Double(sliderDistanceOfPoints.minimumValue) {
            distanceBetweenPoints = distanceBetweenPoints - 0.1
            sliderDistanceOfPoints.value = Float(distanceBetweenPoints)
            changeSineWave()
        }
    }
    
    @IBAction func btnRedDotClicked(_ sender: UIButton) {
        btnBlueDot.layer.borderColor = UIColor.clear.cgColor
        sender.layer.borderColor = UIColor.black.cgColor
        viewSineWave.selectedPointColor = UIColor.init(named: "Reddish")
    }
    
    @IBAction func btnBlueDot(_ sender: UIButton) {
        btnRedDot.layer.borderColor = UIColor.clear.cgColor
        sender.layer.borderColor = UIColor.black.cgColor
        viewSineWave.selectedPointColor = UIColor.init(named: "Blueish")
    }
    
    @IBAction func btnClearAllClicked(_ sender: Any) {
        viewSineWave.removeDot()
        viewSineWave.isPointSelection = false
        infoView.isHidden = true
        textView.text = "Select any point from graph"
        changeSineWave()
    }
    
    @IBAction func btnCloseInfoViewCliked(_ sender: Any) {
        viewSineWave.isPointSelection = false
        infoView.isHidden = true
        changeSineWave()
    }
    
    @IBAction func btnGetPointInfoClicked(_ sender: Any) {
        viewSineWave.isPointSelection = true
        infoView.isHidden = false
    }
    
    @IBAction func btnCloseUnitCircleClicked(_ sender: Any) {
        viewUnitCircle.isHidden = true
    }
    
    @IBAction func btnZoomUnitCircleClicked(_ sender: Any) {
        viewUnitCircle.isHidden = false
    }
    
    @IBAction func waveTypeValueChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewSineWave.function = .sin
            break
        case 1:
            viewSineWave.function = .cos
            break
        case 2:
            viewSineWave.function = .tan
            break
        case 3:
            viewSineWave.function = .cot
            break
        case 4:
            viewSineWave.function = .sec
            break
        case 5:
            viewSineWave.function = .cosec
            break
        default:
            break
        }
        viewSineWave.isPointSelection = false
        infoView.isHidden = true
        textView.text = "Select any point from graph"
        changeSineWave()
    }
    
    //MARK: - Methods
    
    func defaultSetUP() {
        btnBlueDot.layer.borderColor = UIColor.black.cgColor
        btnRedDot.layer.borderColor = UIColor.clear.cgColor
        btnBlueDot.layer.borderWidth = 3
        btnRedDot.layer.borderWidth = 3
        infoView.isHidden = true
        viewUnitCircle.isHidden = true
        textView.font = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? UIFont.systemFont(ofSize: 24) : UIFont.systemFont(ofSize: 17)
        viewSineWave.delegate = self
        changeSineWave()
        frequencySlider.maximumValue = 100.0
    }
    
    func changeSineWave() {
        lblAmplitude.text = "Amplitude : " + (amplitude * 2.0).description
        lblFrequency.text = "Frequency : " + frequency.description
        lblDistanceBetweenPoints.text = "Dist. of points : " + distanceBetweenPoints.description
        viewSineWave.amplitude = self.amplitude
        viewSineWave.frequency = self.frequency
        viewSineWave.distanceBetweenPoints = self.distanceBetweenPoints
        lblDegrees.text = "Degree : "
        lblRadians.text = "Radians : "
        viewSineWave.selectedPoint = nil
        infoView.isHidden = true
        textView.text = "Select any point from graph"
        viewSineWave.setNeedsDisplay()
    }
    
    func getValueAtPoint(degree: Int, radian: Double, xVal: Double, yVal: Double) {
        lblDegrees.text = "Degree : " + degree.description
        lblRadians.text = "Radians : " + radian.description
    }
    
    func setValueFromSelectedPoint(graphVal: DUGraphValues) {
        let strDegree = graphVal.degree.description
        let circleRotate = CGFloat(CGFloat(graphVal.degree) / 360.0)
        textView.text = "Point info : \n* Degree: \(strDegree)º  \n* Radian: \(String(format:"%.1f", graphVal.radians)), \n* X: \(String(format:"%.1f", graphVal.xVal)),     Y: \(String(format:"%.1f", graphVal.yVal)). \n* Rotations = \(strDegree)º/360º = \(String(format:"%.1f", circleRotate)) \n* Degree is \(strDegree)º means that circle rotates \(String(format:"%.1f", circleRotate)) times for geting current sinewave pattern with set frequencey and amplitude."
        
    }
}

