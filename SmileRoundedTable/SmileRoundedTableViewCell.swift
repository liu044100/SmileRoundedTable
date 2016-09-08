//
//  SmileRoundedTableViewCell.swift
//
//  Created by rain on 2/16/16.
//  Copyright © 2016 rain. All rights reserved.
//

import UIKit


///This class imitate the default separator & selectionStyle, the tableViewCell handle the style of self
@IBDesignable
public class SmileRoundedTableViewCell: UITableViewCell {

    //MARK: IBInspectable Public Property
    @IBInspectable public var margin: CGFloat = 28
    @IBInspectable public var cornerRadius: CGFloat = 6
    
    @IBInspectable public var selectedColor: UIColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    @IBInspectable public var contentColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.contentViews.forEach { $0.backgroundColor = contentColor }
        }
    }
    
    //MARK: Constant
    private let defaultSeparatorColor = UIColor(red: 206/255, green: 206/255, blue: 210/255, alpha: 1)
    
    //MARK: Private Property
    ///the view cover top corner of contentView
    private let topCornerCoverView = UIView()
    
    ///the view cover bottom corner of contentView
    private let bottomCornerCoverView = UIView()
    
    private let roundedView = UIView()
    
    private let separatorView = UIView()
    
    private var contentViews: [UIView] {
        return [roundedView, topCornerCoverView, bottomCornerCoverView]
    }
    
    //MARK: Setter
    override public var frame: CGRect {
        didSet {
            super.frame.origin.x += margin
            guard let tableview = tableview() else { return }
            //only change frame when cell frame == talbe view frame
            guard tableview.frame.width == super.frame.size.width else { return }
            super.frame.size.width -= 2 * margin
        }
    }
    
    //MARK: Selected
    public var canSelected: Bool = true
    
    public override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        handleSelected(highlighted, animated: animated)
    }
    
    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        handleSelected(selected, animated: animated)
    }

    //MARK: Life Cycle
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let tableView = tableview() else { return }
        
        self.separatorView.backgroundColor = tableView.separatorColor ?? defaultSeparatorColor
        
        //Because this class create a new separator view to imitate the default separator, so set tableView separatorStyle to None
        tableView.separatorStyle = .None
        
        //Because this class imitate the default selection, so disable default selectionStyle
        self.selectionStyle = .None
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        //color
        self.selectedBackgroundView = nil
        self.backgroundColor        = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        
        //corner radius
        roundedView.layer.cornerRadius = cornerRadius

        //add subview
        self.insertSubview(roundedView, belowSubview: contentView)
        self.insertSubview(topCornerCoverView, belowSubview: roundedView)
        self.insertSubview(bottomCornerCoverView, belowSubview: contentView)
        bottomCornerCoverView.addSubview(separatorView)
        
        //set frame
        let width  = self.bounds.size.width
        let height = self.bounds.size.height
        let origin = self.bounds.origin
        let coverViewSize = CGSize(width: width, height: height - cornerRadius)
        let separatorHeight: CGFloat = 0.5
        
        roundedView.frame   = self.bounds
        separatorView.frame = CGRect(origin: CGPoint(x: 0, y: coverViewSize.height - separatorHeight), size: CGSize(width: width, height: separatorHeight))
        topCornerCoverView.frame    = CGRect(origin: origin, size: coverViewSize)
        bottomCornerCoverView.frame = CGRect(origin: CGPoint(x: origin.x, y: origin.y + cornerRadius), size: coverViewSize)
        
        //autoresize
        roundedView.autoresizingMask   = [.FlexibleWidth, .FlexibleHeight]
        separatorView.autoresizingMask = [.FlexibleWidth, .FlexibleLeftMargin, .FlexibleRightMargin]
        topCornerCoverView.autoresizingMask    = [.FlexibleTopMargin, .FlexibleWidth, .FlexibleHeight]
        bottomCornerCoverView.autoresizingMask = [.FlexibleBottomMargin, .FlexibleWidth, .FlexibleHeight]
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateCorner()
        updateSeparator()
    }
    
    //MARK: Help Method
    private func tableview() -> UITableView? {
        guard let view = superview as? UITableView else {
            return superview?.superview as? UITableView
        }
        return view
    }
    
    private func updateCorner() {
        //update cell round corner style
        guard let tableView = tableview(), indexPath = tableView.indexPathForRowAtPoint(self.center) else { return }
        
        if indexPath.row == 0 && tableView.numberOfRowsInSection(indexPath.section) == 1 {
            self.topCornerCoverView.hidden    = true
            self.bottomCornerCoverView.hidden = true
        } else if indexPath.row == 0 {
            self.topCornerCoverView.hidden    = true
            self.bottomCornerCoverView.hidden = false
        } else if indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1 {
            self.topCornerCoverView.hidden    = false
            self.bottomCornerCoverView.hidden = true
        } else {
            self.topCornerCoverView.hidden    = false
            self.bottomCornerCoverView.hidden = false
        }
    }
    
    private func updateSeparator() {
        let leftInset  = self.separatorInset.left
        
        let previousOrigin = separatorView.frame.origin
        
        separatorView.frame.origin = CGPoint(x: leftInset, y: previousOrigin.y)
    }
    
    private func handleSelected(highlighted: Bool, animated: Bool) {
        guard self.canSelected else { return }
        
        let color = highlighted ? selectedColor : contentColor
        
        guard animated else {
            self.contentViews.forEach { $0.backgroundColor = color }
            return
        }
        
        UIView.animateWithDuration(0.6) { () -> Void in
            self.contentViews.forEach { $0.backgroundColor = color }
        }
    }
}
