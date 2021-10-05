//
//  FavouriteView.swift
//  WookieMovies
//
//  Created by Vincent Coetzee on 5/10/21.
//

import UIKit

///
///
/// A Favourite provides an image of a heart which can be filled
/// in and marked as selected by tapping on it. Used to mark a
/// movie as a favourite.
///
/// 
public class FavouriteView: UIImageView
    {
    private static let kUnselectedImageName = "heart"
    private static let kSelectedImageName = "heart.fill"
    private static let kDefaultTintColor = UIColor.orange
    
    public var delegate: FavouriteViewDelegate?
    
    public var isSelected = false
        {
        didSet
            {
            self.updateImage()
            self.delegate?.favouriteView(self,isFavourite: self.isSelected)
            }
        }
    
    private func updateImage()
        {
        self.image = UIImage(systemName: self.isSelected ? Self.kSelectedImageName : Self.kUnselectedImageName)
        }
        
    public override func awakeFromNib()
        {
        super.awakeFromNib()
        self.isSelected = false
        self.isUserInteractionEnabled = true
        self.tintColor = Self.kDefaultTintColor
        self.updateImage()
        }
        
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
        self.isSelected = !self.isSelected
        self.updateImage()
        }
    }
