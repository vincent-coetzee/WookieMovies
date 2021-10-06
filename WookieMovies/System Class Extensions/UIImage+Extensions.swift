//
//  UIImage+Extensions.swift
//  WookieMovies
//
//  Created by Vincent Coetzee on 6/10/21.
//

import UIKit

extension UIImage
    {
    public func withBackground(color: UIColor, opaque: Bool = true) -> UIImage
        {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        guard let context = UIGraphicsGetCurrentContext(), let image = cgImage else
            {
            return self
            }
        defer
            {
            UIGraphicsEndImageContext()
            }
        let rect = CGRect(origin: .zero, size: size)
        context.setFillColor(color.cgColor)
        context.fill(rect)
        context.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))
        context.draw(image, in: rect)
        return(UIGraphicsGetImageFromCurrentImageContext() ?? self)
        }
    }
