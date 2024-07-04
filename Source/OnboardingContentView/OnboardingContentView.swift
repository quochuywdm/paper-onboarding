//
//  OnboardingContentView.swift
//  AnimatedPageView
//
//  Created by Alex K. on 21/04/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

protocol OnboardingContentViewDelegate: AnyObject {

    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo?
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int)
}

class OnboardingContentView: UIView {

    fileprivate struct Constants {
        static let dyOffsetAnimation: CGFloat = 110
        static let showDuration: Double = 0.8
        static let hideDuration: Double = 0.2
    }

    fileprivate var currentItem: OnboardingContentViewItem?
    weak var delegate: OnboardingContentViewDelegate?

    init(itemsCount _: Int, delegate: OnboardingContentViewDelegate) {
        self.delegate = delegate
        super.init(frame: CGRect.zero)

        commonInit()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: public

extension OnboardingContentView {

    func currentItem(_ index: Int, animated _: Bool) {

        let showItem = createItem(index)
        showItemView(showItem, duration: Constants.showDuration)

        hideItemView(currentItem, duration: Constants.hideDuration)

        currentItem = showItem
    }
}

// MARK: life cicle


// MARK: create

extension OnboardingContentView {

    fileprivate func commonInit() {

        currentItem = createItem(0)
    }

    fileprivate func createItem(_ index: Int) -> OnboardingContentViewItem {
        
        let item = OnboardingContentViewItem()
        self.addSubview(item)
        item.backgroundColor = .clear
        
        item.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            item.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            item.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            item.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            item.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
        
        
        guard let info = delegate?.onboardingItemAtIndex(index) else {
            return item
        }

        item.imageView?.image = info.informationImage
        item.titleLabel?.text = info.title
        item.titleLabel?.font = info.titleFont
        item.titleLabel?.textColor = info.titleColor
        item.descriptionLabel?.text = info.description
        item.descriptionLabel?.font = info.descriptionFont
        item.descriptionLabel?.textColor = info.descriptionColor

        delegate?.onboardingConfigurationItem(item, index: index)
        return item
    }
}

// MARK: animations

extension OnboardingContentView {

    fileprivate func hideItemView(_ item: OnboardingContentViewItem?, duration: Double) {
        guard let item = item else { return }
        
        item.layoutIfNeeded()
        self.layoutIfNeeded()
        
        let image = item.stackView.takeScreenshot()
        item.stackView.alpha = 0
        let imageView = UIImageView(image: image)
        item.addSubview(imageView)
        imageView.frame = item.stackView.frame
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseOut, animations: {
            item.alpha = 0
            imageView.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y - 200, width: imageView.frame.width, height: imageView.frame.height)
            item.layoutIfNeeded()
            self.layoutIfNeeded()
        },
                       completion: { _ in
            item.removeFromSuperview()
        })
    }

    fileprivate func showItemView(_ item: OnboardingContentViewItem, duration: Double) {
        item.layoutIfNeeded()
        item.alpha = 0
        layoutIfNeeded()
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseOut, animations: {
            item.alpha = 0
            item.alpha = 1
            item.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
            item.layoutIfNeeded()
            self.layoutIfNeeded()
        }, completion: nil)
    }
}




extension UIView {
func takeScreenshot() -> UIImage {
    
    // Begin context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
    defer { UIGraphicsEndImageContext() }
    
    // Draw view in that context
    drawHierarchy(in: self.bounds, afterScreenUpdates: true)
    
    // And finally, get image
    let image = UIGraphicsGetImageFromCurrentImageContext()
    
    if (image != nil)
    {
        return image!
    }
    return UIImage()
}

func takeScreenShotTransparent() -> UIImage? {
    
    let size = CGSize(width: frame.size.width, height: frame.size.height)
    let rect = CGRect.init(origin: .init(x: 0, y: 0), size: frame.size)
    
    UIGraphicsBeginImageContext(size)
    drawHierarchy(in: rect, afterScreenUpdates: true)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    guard let imageData = image?.pngData() else {
        return nil
    }
    
    return UIImage.init(data: imageData)
}

}
