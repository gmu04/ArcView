//
//  MyView.swift
//  Created by Gokhan Mutlu on 22.05.2021.
//

import UIKit

@IBDesignable
class GMArcView: UIView {

    //MARK:- Properties
    
    private(set) var colors:[UIColor] = [#colorLiteral(red: 0, green: 0.8823529412, blue: 0.7764705882, alpha: 1), #colorLiteral(red: 0.6156862745, green: 0.9215686275, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.5882352941, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0, green: 0.8823529412, blue: 0.2941176471, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
    
    private(set) var rect:CGRect = .zero
    
    //used to check whih path is tapped
    private var paths:[UIBezierPath]!
    
    /**
     Width of arc
     */
    @IBInspectable var arcLineWidth:CGFloat = 12 {
        didSet{
            if arcLineWidth < 4 || arcLineWidth > 20 {
                self.arcLineWidth = oldValue
            }
        }
    }
    /**
     Width of selected arc
     */
    var arcLineWidthSelected:CGFloat { arcLineWidth + (arcLineWidth/2) }
    
    var valueLabel:UILabel = {
        let label  = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.sizeToFit()
        return label
    }()
    var titleLabel:UILabel = {
        let label  = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
    /**
     Data to  represent
     */
    var data:[ArcData]! = nil
    
    /*
    #if DEBUG
    var data = ArcData.all()
    #endif*/
    
    /**
     Sum of data, in order to calculate angle of arc(s)
     */
    private var sum:Double{ data.reduce(0.0) { $0 + $1.value } }
   
    
    //MARK:- Drawing
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard data != nil else { return }
        
        self.rect = rect
       
        var previousAngle = 0.0
        let totalDegrees = 270.0 //degrees
        var endAngle = 0.0
        var arcType:ArcType
        //let lineWidth:CGFloat = 12
        
        paths = [UIBezierPath]()
        for (idx,arcData) in data.enumerated() {
            
            //set arc type
            if idx == 0 { arcType = .first }
            else if idx == data.count-1 { arcType = .last }
            else { arcType = .any }
            
            //set end angle
            let calc = totalDegrees * arcData.value / sum
            endAngle = previousAngle+calc
            
            drawArc(rect,
                    startAngle: 135 + previousAngle,
                    endAngle: 135 + previousAngle+calc,
                    lineWidth: (arcData.isSelected ? arcLineWidthSelected : arcLineWidth),
                    color: colors[idx],
                    arcType: arcType)
            
            previousAngle = endAngle
        }

    }
    
    private func drawArc(_ rect:CGRect,
                         startAngle:Double,
                         endAngle:Double,
                         lineWidth:CGFloat,
                         color:UIColor,
                         arcType:ArcType,
                         isSelected:Bool = false
    ){
        
        let arcCenter = CGPoint(x: rect.midX, y: rect.midY)
        let radius = (min(rect.width, rect.height) / 2) - (arcLineWidthSelected/2)
        
        //leave a space after endAngle of the arc
        let defaultSpaceBetweenArcs = 1.5
        
        let path = UIBezierPath(arcCenter: arcCenter,
                                radius: radius,
                                startAngle: startAngle.toRadians(),
                                endAngle: endAngle.toRadians() -
                                    (arcType == .last ? 0 : defaultSpaceBetweenArcs).toRadians(),
                                 clockwise: true)
        path.lineWidth = lineWidth
        color.setStroke()

        path.stroke()

        paths.append(path)
        
        
        switch arcType {
        case .first:
            
            let path2 = UIBezierPath(arcCenter: arcCenter,
                                     radius: radius,
                                     startAngle: 134.toRadians(),
                                     endAngle: 135.toRadians(),
                                     clockwise: true)
            path2.lineCapStyle = .round
            path2.lineWidth = lineWidth
            color.setStroke()
            path2.stroke()

            // draw round at the end of arc
            if data.count == 1 {
                fallthrough
            }
        case .last:
            let path3 = UIBezierPath(arcCenter: arcCenter,
                                     radius: radius,
                                     startAngle: 44.toRadians(),
                                     endAngle: 45.toRadians(),
                                     clockwise: true)
            
            UIColor.red.setStroke()
            path3.lineCapStyle = .round
            path3.lineWidth = lineWidth
            color.setStroke()
            path3.stroke()
            
        default:
            break
        }
        
    }
    
    
    //MARK:- Handle events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = (touch?.location(in: self))!
        
        paths.enumerated().forEach { idx,path in
            if path.bounds.contains(point) {
                //print("\(Date()) TAPPED - \(idx)")
                for idx in 0..<data.count{
                    self.data[idx].isSelected = false
                }
                
                data[idx].isSelected = true

                
                //adding value & title labels
                if !self.subviews.contains(valueLabel){
                    valueLabel.frame = CGRect(origin: .zero, size: rect.size)
                    self.addSubview(valueLabel)

                    titleLabel.frame = CGRect(origin: .zero, size: rect.size)
                    self.addSubview(titleLabel)
                    
                    
                    self.valueLabel.alpha = 0
                    self.titleLabel.alpha = 0
                    let delay = 0.0 //sec
                    UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseOut, animations: {
                        self.valueLabel.alpha = 1
                        self.titleLabel.alpha = 1
                    })

                    NSLayoutConstraint.activate([
                        valueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                        valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20),
                        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                        titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 10)

                    ])
                }
                self.valueLabel.text = "$ \(data[idx].value)"
                self.titleLabel.text = String(data[idx].description)
                
                self.setNeedsDisplay(self.rect)
            }
        }
    }
   
}



