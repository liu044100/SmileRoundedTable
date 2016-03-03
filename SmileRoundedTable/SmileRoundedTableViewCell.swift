//
//  SmileRoundedTableViewCell.swift
//
//  Created by rain on 2/16/16.
//  Copyright © 2016 rain. All rights reserved.
//

import UIKit

struct ConstraintHelper {
    static func addEqualConstraintsFromView(view: UIView, toView: UIView) {
        let topConstraint = toView.topAnchor.constraintEqualToAnchor(view.topAnchor)
        let bottomConstraint = toView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        let leftConstraint = toView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = toView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        NSLayoutConstraint.activateConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    static func addBottomConstraintsFromView(view: UIView, toView: UIView, constant: CGFloat) {
        let topConstraint = toView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: -constant)
        let bottomConstraint = toView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        let leftConstraint = toView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = toView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        NSLayoutConstraint.activateConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    static func addTopConstraintsFromView(view: UIView, toView: UIView, constant: CGFloat) {
        let topConstraint = toView.topAnchor.constraintEqualToAnchor(view.topAnchor)
        let bottomConstraint = toView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: constant)
        let leftConstraint = toView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = toView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        NSLayoutConstraint.activateConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }

}

public class SmileRoundedTableViewCell: UITableViewCell {

    //MARK: Property - IBInspectable
    public var cornerRadius: CGFloat = 6
    public var margin: CGFloat = 28
    public var frontColor: UIColor = UIColor.whiteColor()
    public var separatorLeftInset: CGFloat = 20
    
    //MARK: Property
    let shapeLayer = CAShapeLayer()
    let lineLayer = CALayer()
    
    let roundView = UIView()
    let topView = UIView()
    let bottomView = UIView()
    
    //margin for draw rect
    private let Margin: CGFloat = 0
    
    //MARK: Setter
    private var separatorLineInset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: separatorLeftInset, bottom: 0, right: 0)
    }
    
    override public var frame: CGRect {
        didSet(newFrame){
            super.frame.origin.x += margin
            if let tableview = getTableview() {
                if tableview.frame.width == super.frame.size.width {
                    super.frame.size.width -= 2 * margin
                }
            }
        }
    }

    public override func didMoveToSuperview() {
        if let tableview = getTableview() {
            tableview.separatorStyle = .None
        }
    }
    
    //MARK: Life Cycle
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        let testColor = UIColor.redColor()
        
        roundView.backgroundColor = testColor
        topView.backgroundColor = testColor
        bottomView.backgroundColor = testColor
        
        roundView.layer.cornerRadius = cornerRadius
        
        self.insertSubview(roundView, belowSubview: self.contentView)
        self.insertSubview(topView, belowSubview: self.contentView)
        self.insertSubview(bottomView, belowSubview: self.contentView)
        
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
        
        roundView.translatesAutoresizingMaskIntoConstraints = false
        topView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        ConstraintHelper.addEqualConstraintsFromView(roundView, toView: self)
        ConstraintHelper.addTopConstraintsFromView(topView, toView: self, constant: cornerRadius)
        ConstraintHelper.addBottomConstraintsFromView(bottomView, toView: self, constant: cornerRadius)
    }
    
    //MARK: Helpe Method
    func getTableview() -> UITableView? {
        if let view = superview as? UITableView {
            return view
        } else {
            return superview?.superview as? UITableView
        }
    }


    //MARK: drawRect
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if let tableview = getTableview(),
            let indexPath = tableview.indexPathForCell(self) {
                if indexPath.row == 0 && tableview.numberOfRowsInSection(indexPath.section) == 1 {
                    self.topView.hidden = true
                    self.bottomView.hidden = true
                } else if indexPath.row == 0 {
                    self.topView.hidden = true
                    self.bottomView.hidden = false
                } else if indexPath.row == tableview.numberOfRowsInSection(indexPath.section) - 1 {
                    self.topView.hidden = false
                    self.bottomView.hidden = true
                } else {
                    self.topView.hidden = false
                    self.bottomView.hidden = false
                }
        }
    }
}

extension SmileRoundedTableViewCell {
    private func CreateTopCornerPath() -> CGMutablePathRef {
        let pathRef: CGMutablePathRef = CGPathCreateMutable()
        
        let height = self.frame.height
        let width = self.frame.width
        
        CGPathMoveToPoint(pathRef, nil, Margin, height)
        CGPathAddLineToPoint(pathRef, nil, Margin, cornerRadius)
        CGPathAddArc(pathRef, nil, Margin + cornerRadius, cornerRadius, cornerRadius, CGFloat(M_PI), CGFloat(3/2.0 * M_PI), false)
        CGPathAddLineToPoint(pathRef, nil, width - Margin - cornerRadius, 0)
        CGPathAddArc(pathRef, nil, width - Margin - cornerRadius,cornerRadius, cornerRadius, CGFloat(3/2 * M_PI), CGFloat(2.0 * M_PI), false)
        CGPathAddLineToPoint(pathRef, nil, width - Margin, height)
        CGPathAddLineToPoint(pathRef, nil, Margin, height)
        return pathRef
    }
    
    private func CreateBottomCornerPath() -> CGMutablePathRef {
        let pathRef: CGMutablePathRef = CGPathCreateMutable()
        
        let height = self.frame.height
        let width = self.frame.width
        CGPathMoveToPoint(pathRef, nil, Margin, 0)
        CGPathAddLineToPoint(pathRef, nil, width - Margin, 0)
        CGPathAddLineToPoint(pathRef, nil, width - Margin, height - cornerRadius)
        CGPathAddArc(pathRef, nil, width - Margin - cornerRadius, height - cornerRadius, cornerRadius, 0, CGFloat(1/2.0 * M_PI), false)
        CGPathAddLineToPoint(pathRef, nil, Margin, height)
        CGPathAddArc(pathRef, nil, Margin + cornerRadius, height - cornerRadius, cornerRadius, CGFloat(1/2 * M_PI), CGFloat(M_PI), false)
        CGPathAddLineToPoint(pathRef, nil, Margin, 0)
        return pathRef
    }
    
    private func CreateBothCornerPath() -> CGMutablePathRef {
        let pathRef: CGMutablePathRef = CGPathCreateMutable()
        
        let height = self.frame.height
        let width = self.frame.width
        
        CGPathMoveToPoint(pathRef, nil, Margin, height - cornerRadius)
        CGPathAddLineToPoint(pathRef, nil, Margin, cornerRadius)
        CGPathAddArc(pathRef, nil, Margin + cornerRadius, cornerRadius, cornerRadius, CGFloat(M_PI), CGFloat(3/2.0 * M_PI), false)
        CGPathAddLineToPoint(pathRef, nil, width - Margin - cornerRadius, 0)
        CGPathAddArc(pathRef, nil, width - Margin - cornerRadius,cornerRadius, cornerRadius, CGFloat(3/2 * M_PI), CGFloat(2.0 * M_PI), false)
        CGPathAddLineToPoint(pathRef, nil, width - Margin, height - cornerRadius)
        CGPathAddArc(pathRef, nil, width - Margin - cornerRadius, height - cornerRadius, cornerRadius, 0, CGFloat(1/2.0 * M_PI), false)
        CGPathAddLineToPoint(pathRef, nil, Margin + cornerRadius, height)
        CGPathAddArc(pathRef, nil, Margin + cornerRadius, height - cornerRadius, cornerRadius, CGFloat(1/2 * M_PI), CGFloat(M_PI), false)
        return pathRef
    }
    
    private func CreateNoneCornerPath() -> CGMutablePathRef {
        let pathRef: CGMutablePathRef = CGPathCreateMutable()
        let height = self.frame.height
        let width = self.frame.width
        CGPathMoveToPoint(pathRef, nil, Margin, 0)
        CGPathAddLineToPoint(pathRef, nil, width - Margin, 0)
        CGPathAddLineToPoint(pathRef, nil, width - Margin, height)
        CGPathAddLineToPoint(pathRef, nil, Margin, height)
        CGPathAddLineToPoint(pathRef, nil, Margin, 0)
        return pathRef
    }
}
