//
//  StarView.swift
//  WookieMovies
//
//  Created by Vincent Coetzee on 5/10/21.
//

import UIKit

@IBDesignable
public class StarView: UIImageView
    {
    private static let kSelectedImage = "star.fill"
    private static let kUnselectedImage = "star"
    
    internal var container: StarsView!
    internal var index: Int = 0
    
    @IBInspectable
    public var isSelected = false
        {
        didSet
            {
            self.updateImage()
            }
        }
    
    private func updateImage()
        {
        self.image = UIImage(systemName: self.isSelected ? Self.kSelectedImage : Self.kUnselectedImage)
        }
        
    public override init(frame: CGRect)
        {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.updateImage()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib()
        {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
        self.updateImage()
        }
        
    internal func toggle()
        {
        self.isSelected = !self.isSelected
        }
        
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
        self.toggle()
        self.container.starTouched(self)
        }
        
    public override func prepareForInterfaceBuilder()
        {
        super.prepareForInterfaceBuilder()
        self.updateImage()
        }
    }
