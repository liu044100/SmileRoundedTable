//
//  SmileRoundedTableViewCell.swift
//
//  Created by rain on 2/16/16.
//  Copyright © 2016 rain. All rights reserved.
//

import UIKit

private struct ConstraintHelper {
    enum Anchor: Int {
        case Top
        case Left
        case Right
        case Bottom
        case Count
        
        static var all: [Anchor] {
            let result = (0..<Anchor.Count.rawValue).map { Anchor(rawValue: $0)! }
            return result
        }
        
        static func anchorsExceptAnchor(anchor: Anchor) -> [Anchor] {
            let result = all.filter { $0.rawValue != anchor.rawValue }
            return result
        }
    }
    
    static func constraintWithAnchor(anchor: Anchor, constant: CGFloat = 0, fromView view: UIView, toView: UIView) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch anchor {
        case .Top:
            constraint = toView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: -constant)
        case .Left:
            constraint = toView.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: -constant)
        case .Right:
            constraint = toView.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: constant)
        case .Bottom:
            constraint = toView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: constant)
        case .Count:
            constraint = toView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        }
        return constraint
    }
    
    static func adjoin(exceptAnchor anchor: Anchor = .Top, hasConstant constant: CGFloat = 0, fromView view: UIView, toView: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(constraintWithAnchor(anchor, constant: constant, fromView: view, toView: toView))
        Anchor.anchorsExceptAnchor(anchor).forEach {
            constraints.append(constraintWithAnchor($0, fromView: view, toView: toView))
        }
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    static func adjoin(exceptAnchor anchor: Anchor, hasConstant constant: CGFloat, noAnchor: Anchor, fromView view: UIView, toView: UIView, withHeight height: CGFloat) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(constraintWithAnchor(anchor, constant: constant, fromView: view, toView: toView))
        Anchor.anchorsExceptAnchor(anchor).filter { $0 != noAnchor }.forEach {
            constraints.append(constraintWithAnchor($0, fromView: view, toView: toView))
        }
        constraints.append(view.heightAnchor.constraintEqualToConstant(height))
        NSLayoutConstraint.activateConstraints(constraints)
    }
}

public class SmileRoundedTableViewCell: UITableViewCell {

    //MARK: Property - IBInspectable
    public var cornerRadius: CGFloat = 6
    public var margin: CGFloat = 28
    public var frontColor = UIColor.whiteColor()
    public var separatorColor = UIColor(red: 206/255, green: 206/255, blue: 210/255, alpha: 1)
    public var separatorLeftInset: CGFloat = 20
    public var selectedColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    
    //MARK: Property
    private let roundView = UIView()
    private let topView = UIView()
    private let bottomView = UIView()
    
    private var separatorLineInset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: separatorLeftInset, bottom: 0, right: 0)
    }
    
    //MARK: Setter
    override public var frame: CGRect {
        didSet(newFrame){
            super.frame.origin.x += margin
            guard let tableview = getTableview() else { return }
            guard tableview.frame.width == super.frame.size.width else { return }
            super.frame.size.width -= 2 * margin
        }
    }

    //MARK: Life Cycle
    public override func didMoveToSuperview() {
        if let tableview = getTableview() {
            tableview.separatorStyle = .None
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
 
        roundView.backgroundColor = frontColor
        topView.backgroundColor = frontColor
        bottomView.backgroundColor = frontColor
        
        roundView.layer.cornerRadius = cornerRadius
        
        self.insertSubview(roundView, belowSubview: self.contentView)
        self.insertSubview(topView, belowSubview: self.contentView)
        self.insertSubview(bottomView, belowSubview: self.roundView)
        
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
        
        roundView.translatesAutoresizingMaskIntoConstraints = false
        topView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        ConstraintHelper.adjoin(fromView: roundView, toView: self)
        ConstraintHelper.adjoin(exceptAnchor: .Bottom, hasConstant: cornerRadius, fromView: topView, toView: self)
        ConstraintHelper.adjoin(exceptAnchor: .Top, hasConstant: cornerRadius, fromView: bottomView, toView: self)
        
        //***separator
        let separator = UIView()
        separator.backgroundColor = separatorColor
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        topView.addSubview(separator)
        ConstraintHelper.adjoin(exceptAnchor: .Left, hasConstant: separatorLeftInset, noAnchor: .Bottom, fromView: separator, toView: topView, withHeight: 0.5)
    }

    
    public override func layoutSubviews() {
        super.layoutSubviews()
        handleRoundCorner()
    }
    
    //MARK: Help Method
    private func getTableview() -> UITableView? {
        guard let view = superview as? UITableView else {
            return superview?.superview as? UITableView
        }
        return view
    }
    
    private func handleRoundCorner() {
        guard let tableView = getTableview(),
            let indexPath = tableView.indexPathForRowAtPoint(self.center) else { return }
        if indexPath.row == 0 && tableView.numberOfRowsInSection(indexPath.section) == 1 {
            self.topView.hidden = true
            self.bottomView.hidden = true
        } else if indexPath.row == 0 {
            self.topView.hidden = true
            self.bottomView.hidden = false
        } else if indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1 {
            self.topView.hidden = false
            self.bottomView.hidden = true
        } else {
            self.topView.hidden = false
            self.bottomView.hidden = false
        }
    }
    
}
