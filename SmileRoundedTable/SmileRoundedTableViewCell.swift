//
//  SmileRoundedTableViewCell.swift
//
//  Created by rain on 2/16/16.
//  Copyright © 2016 rain. All rights reserved.
//

import UIKit

@IBDesignable
public class SmileRoundedTableView: UITableView {
    @IBInspectable public var margin: CGFloat = 28
    @IBInspectable public var cornerRadius: CGFloat = 8
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        configureCellsMargin()
        configureCellsCornerRadius()
        configureHeaderFooterMargin()
    }
    
    private func configureCellsCornerRadius() {
        roundedTableViewCells()?
            .forEach {
                $0.cornerRadius = cornerRadius
        }
    }
    
    private func configureCellsMargin() {
        roundedTableViewCells()?
            .filter {
                $0.frame.size.width + 2 * margin != self.frame.size.width
            }
            .forEach { cell in
                cell.frame.origin.x += margin
                cell.frame.size.width -= 2 * margin
        }
    }
    
    private func roundedTableViewCells() -> [SmileRoundedTableViewCell]? {
        let wrapperView = self.subviews.first
        return wrapperView?.subviews.filter { $0 is SmileRoundedTableViewCell } as? [SmileRoundedTableViewCell]
    }
    
    private func configureHeaderFooterMargin() {
        tableHeaderFooterViews()
            .filter {
                $0.frame.origin.x != margin
            }
            .forEach {
                $0.frame.origin.x = margin
        }
    }
    
    private func tableHeaderFooterViews() -> [UIView] {
        let headerViews = (0..<numberOfSections)
            .map { headerViewForSection($0) }
            .flatMap { $0 }
        
        let footerViews = (0..<numberOfSections)
            .map { footerViewForSection($0) }
            .flatMap { $0 }
        
        return headerViews + footerViews
    }
}

///This class imitate the default selectionStyle, the tableViewCell handle the style of self
@IBDesignable
public class SmileRoundedTableViewCell: UITableViewCell {
    
    //MARK: Public Property
    public var cornerRadius: CGFloat = 0 {
        didSet {
            guard oldValue != cornerRadius else { return }
            roundedView.layer.cornerRadius = cornerRadius
            configureContentViewFrame()
        }
    }
    
    //MARK: IBInspectable Public Property
    @IBInspectable public var selectedColor: UIColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    @IBInspectable public var contentColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.contentViews.forEach { $0.backgroundColor = contentColor }
        }
    }
    
    //MARK: Private Property
    ///the view cover top corner of contentView
    private let topCornerCoverView = UIView()
    ///the view cover bottom corner of contentView
    private let bottomCornerCoverView = UIView()
    private let roundedView = UIView()
    
    private var contentViews: [UIView] {
        return [roundedView, topCornerCoverView, bottomCornerCoverView]
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
        
        //Because this class imitate the default selection, so disable default selectionStyle
        self.selectionStyle = .None
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        //color
        self.backgroundColor        = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        
        //add subview
        self.insertSubview(roundedView, belowSubview: contentView)
        self.insertSubview(topCornerCoverView, belowSubview: roundedView)
        self.insertSubview(bottomCornerCoverView, belowSubview: contentView)
        
        //set frame
        configureContentViewFrame()
        
        //autoresize
        roundedView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        topCornerCoverView.autoresizingMask = [.FlexibleTopMargin, .FlexibleWidth, .FlexibleHeight]
        bottomCornerCoverView.autoresizingMask = [.FlexibleBottomMargin, .FlexibleWidth, .FlexibleHeight]
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateRoundCorner()
    }
    
    //MARK: Help Method
    private func tableview() -> UITableView? {
        guard let view = superview as? UITableView else {
            return superview?.superview as? UITableView
        }
        return view
    }
    
    private func configureContentViewFrame() {
        let width  = self.bounds.size.width
        let height = self.bounds.size.height
        let origin = self.bounds.origin
        let coverViewSize = CGSize(width: width, height: height - cornerRadius)
        
        roundedView.frame = self.bounds
        topCornerCoverView.frame = CGRect(origin: origin, size: coverViewSize)
        bottomCornerCoverView.frame = CGRect(origin: CGPoint(x: origin.x, y: origin.y + cornerRadius), size: coverViewSize)
    }
    
    private func updateRoundCorner() {
        //update cell round corner style
        guard let tableView = tableview(), indexPath = tableView.indexPathForRowAtPoint(self.center) else { return }
        
        if indexPath.row == 0 && tableView.numberOfRowsInSection(indexPath.section) == 1 {
            self.topCornerCoverView.hidden    = true
            self.bottomCornerCoverView.hidden = true
            hideSeparator(true)
        } else if indexPath.row == 0 {
            self.topCornerCoverView.hidden    = true
            self.bottomCornerCoverView.hidden = false
            hideSeparator(false)
        } else if indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1 {
            self.topCornerCoverView.hidden    = false
            self.bottomCornerCoverView.hidden = true
            hideSeparator(true)
        } else {
            self.topCornerCoverView.hidden    = false
            self.bottomCornerCoverView.hidden = false
            hideSeparator(false)
        }
    }
    
    private func hideSeparator(hidden: Bool) {
        let separatorViews = self.subviews.filter {
            //separator line height < 1
            $0.frame.height < 1
        }
        
        //always hide cell's top separator
        separatorViews.filter { $0.frame.origin.y == 0 }.first?.hidden = true
        
        //configure bottom separator
        separatorViews.filter { $0.frame.origin.y != 0 }.first?.hidden = hidden
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
