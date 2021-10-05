//
//  StarsView.swift
//  WookieMovies
//
//  Created by Vincent Coetzee on 5/10/21.
//

import UIKit

@IBDesignable
class StarsView: UIView
    {
    private var stars = Array<StarView>()
    
    public var movie: Movie?
        {
        didSet
            {
            if let movie = self.movie
                {
                for index in 0..<movie.starCount
                    {
                    self.stars[index].isSelected = true
                    }
                }
            }
        }
    private var count:Int
        {
        var count = 0
        for star in self.stars
            {
            count += star.isSelected ? 1 : 0
            }
        return(count)
        }
        
    public override func awakeFromNib()
        {
        super.awakeFromNib()
        for index in 0..<5
            {
            let star = StarView(frame:.zero)
            star.index = index
            self.stars.append(star)
            self.addSubview(star)
            star.container = self
            }
        self.setNeedsLayout()
        }
        
    public func starTouched(_ starView: StarView)
        {
        let index = self.count
        guard index > 0 else
            {
            if self.count == 1
                {
                self.stars[0].isSelected = !self.stars[0].isSelected
                }
            return
            }
        for star in self.stars
            {
            star.isSelected = false
            }
        for loop in 0..<index
            {
            self.stars[loop].isSelected = true
            }
        self.movie?.starCount = self.count
        }
        
    public override func layoutSubviews()
        {
        let myBounds = self.bounds
        let height = myBounds.size.height
        let width = myBounds.size.width / 5
        var leading:CGFloat = 0
        for star in stars
            {
            star.frame = CGRect(x: leading,y: 0,width: width,height: height)
            leading += width
            }
        }
        
    public override func prepareForInterfaceBuilder()
        {
        super.prepareForInterfaceBuilder()
        for index in 0..<5
            {
            let star = StarView(frame:.zero)
            star.index = index
            star.isSelected = false
            self.stars.append(star)
            self.addSubview(star)
            star.container = self
            }
        self.setNeedsLayout()
        }
    }
